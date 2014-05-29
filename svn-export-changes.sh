#!/bin/bash -e

if [ ! $1 ]; then
    echo "Please enter an SVN repository location"
    exit
fi

# set up nice names for the incoming parameters to make the script more readable
repository=$1
revision_from=$2
revision_to=$3
target_directory=$4

: ${revision_to:="HEAD"} 
: ${revision_from:="PREV"}
: ${target_directory:="incre-deploy"} 


# the grep is needed so we only get added/modified files and not the deleted ones or anything else
# if it's a modified directory it's " M" so won't show with this command (good)
# if it's an added directory it's still "A" so will show with this command (not so good)

# clear out directory first, suppress errors
rm -R $target_directory &2>/dev/null

echo -e "\033[38;5;148mCleaning export directory\033[39m"

# Begin export
echo -e "\033[00;31mExporting files revised between $revision_from and $revision_to to /$target_directory\033[39m"

# trim $repository
repository=`echo "$repository" | sed 's|/*$||'`

for line in `svn diff --summarize -r$revision_from:$revision_to $repository | grep "^[AM]"`
do
    # each line in the above command in the for loop is split into two:
    # 1) the status line (containing A, M, AM, D etc)
    # 2) the full repository and filename string
    # so only export the file when it's not the status line
    if [ $line != "A" ] && [ $line != "AM" ] && [ $line != "M" ]; then
        # use sed to remove the repository from the full repo and filename
        filename=`echo "$line" |sed "s|$repository||g"`
        echo "$filename"
        # don't export if it's a directory we've already created
        if [ ! -d $target_directory/$filename ]; then
            directory=`dirname $filename`
            echo $directory
            IS_DIR_WEB=`echo "$directory" | grep -P '^WebContent/*'`;
            # 1) files not under 'WebContent', exports go to 'WEB-INF/classes/'
            # 2) files under 'WebContent', exports to the root of $target_directory
            if [ $IS_DIR_WEB ]; then
                # for 'src' directory, class files will be exported for java sources
                trim_dir="WEB-INF/classes/"`echo "$directory" | sed 's|^/||' | sed 's|[^/]*/*||'`
                mkdir -p "$target_directory/$trim_dir"
                filename="WEB-INF/classes/"`echo "$filename" | sed 's|^/||' | sed 's|[^/]*/||' | sed 's|.java$|.class|'`
                echo "$filename"
                cp "$repository/WebContent/$filename" "$target_directory/$filename"
            else
                mkdir -p "$target_directory/$IS_DIR_WEB"
                echo "$filename"
                filename=`echo "$filename" | sed 's|^WebContent/||'`;
                svn export -qr $revision_to $line $target_directory/$filename
                exit;
            fi
        fi
    fi
done

# to summarize any deleted files or directories at the end of the script uncomment the following line
#svn diff --summarize -r$revision_from:$revision_to $repository | grep "^[D]"
