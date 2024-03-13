struct Item
    name::String
    size::Int
end

function Item(s::String)
    sizestr, filename = split(s)
    return Item(string(filename), parse(Int, sizestr))
end



abstract type AbstractFolder end

function cd(folder::AbstractFolder, key::String)
    key == "/" && return root(folder)
    key == ".." && return parent(folder)
    return folder.contents[key]
end



const ContentTypes = Union{AbstractFolder, Item}



struct RootFolder <: AbstractFolder
    name::String
    contents::Dict{String, ContentTypes}
    depth::Int

    function RootFolder()
        name = "/"
        depth = 0
        contents = Dict{String, ContentTypes}()
        new(name, contents, depth)
    end
end

root(folder::RootFolder) = folder
parent(folder::RootFolder) = folder



struct Folder <: AbstractFolder
    name::String
    contents::Dict{String, ContentTypes}
    parent::AbstractFolder
    root::RootFolder
    depth::Int

    function Folder(name::String, parent::AbstractFolder)
        new(name, Dict{String, ContentTypes}(), parent, root(parent), parent.depth + 1)
    end
end

root(folder::Folder) = folder.root
parent(folder::Folder) = folder.parent


addfile!(folder::AbstractFolder, item::Item) = folder.contents[item.name] = item
addfolder!(folder::AbstractFolder, newFolder::Folder) = folder.contents[newFolder.name] = newFolder



function read_ls(io::IOStream, currentfolder::AbstractFolder)
    dir_re = r"^dir (\S+)$"
    item_re = r"^\d+ \S+$"

    while !eof(io)
        r = readline(io)

        startswith(r, '$') && return r
        
        m = match(dir_re, r)
        if m !== nothing
            folder = Folder(string(m[1]), currentfolder)
            addfolder!(currentfolder, folder)
        end

        m = match(item_re, r)
        if m !== nothing
            addfile!(currentfolder, Item(r))
        end
    end
end

function createfilesystemtree(io::IOStream)
    root = RootFolder()
    currentfolder = root

    cd_re = r"^\$ cd (\S+)$"
    ls_re = r"^\$ ls$"

    r = readline(io)

    while !eof(io)
        if startswith(r, '$') # command (cd or ls)

            m = match(cd_re, r)
            if m !== nothing
                currentfolder = cd(currentfolder, string(m[1]))
                r = readline(io)
                continue
            end
            
            m = match(ls_re, r)
            if m !== nothing
                r = read_ls(io, currentfolder)
                continue
            end
                
            error("unrecognized command '$r'")
        end

        r = readline(io)
    end

    return root
end

fs = createfilesystemtree(open("data/input07", "r"))


function filesize(folder::AbstractFolder)
    s = 0
    
    for content in values(folder.contents)
        if content isa Item
            s += content.size
        elseif  content isa Folder
            s += filesize(content)         
        end
    end

    return s
end

filesize(fs)



function sumfilesizesatmost(node::RootFolder, most::Int)
    s = Vector{Int}()
    
    sizeofnode = filesize(node)
    if sizeofnode <= most
        push!(s, sizeofnode)
    end

    for content in values(node.contents)
        if content isa Folder
            sumfilesizesatmost(content, most, s)
        end
    end

    return s
end

function sumfilesizesatmost(node::Folder, most::Int, s::Vector{Int})
    sizeofnode = filesize(node)
    if sizeofnode <= most
        push!(s, sizeofnode)
    end

    for content in values(node.contents)
        if content isa Folder
            sumfilesizesatmost(content, most, s)
        end
    end
end

s = sumfilesizesatmost(fs, 100_000)
sum(s)




function whichfiletodelete(node::RootFolder, spaceneeded::Int, totalsystemsize::Int)
    D = Dict{String, Int}()
    spaceavailable = totalsystemsize - filesize(node)

    for content in values(node.contents)
        if content isa Folder
            whichfiletodelete(content, spaceneeded, spaceavailable, D)
        end
    end

    return D
end


function whichfiletodelete(node::Folder, spaceneeded::Int, spaceavailable::Int, candidates::Dict{String, Int})
    spaceofthisdir = filesize(node)
    if spaceavailable + spaceofthisdir >= spaceneeded
        candidates[node.name] = spaceofthisdir
    end

    for content in values(node.contents)
        if content isa Folder
            whichfiletodelete(content, spaceneeded, spaceavailable, candidates)
        end
    end
end

candidates = whichfiletodelete(fs, 30000000, 70000000)

sizeofdir = minimum(values(candidates))
findfirst(kvp -> kvp == sizeofdir, candidates)