# Auto-venv activator (project root only)
   cd() {
       builtin cd "$@" || return

       dir=$(pwd)
       while [ "$dir" != "/" ]; do
           if [ -f "$dir/manage.py" ]; then
               project_root="$dir"
               break
           fi
           dir=$(dirname "$dir")
       done

       if [ -n "$project_root" ] && [ "$(pwd)" = "$project_root" ]; then
           if [ -d "$project_root/.venv" ]; then
               if [ -f "$project_root/.venv/bin/activate" ]; then
                   source "$project_root/.venv/bin/activate"
                   echo "Activated virtualenv in $project_root"
               fi
           else
               echo "Creating .venv in $project_root"
               python3 -m venv "$project_root/.venv"
               source "$project_root/.venv/bin/activate"
               echo "Activated new virtualenv in $project_root"
           fi
       fi
   }
