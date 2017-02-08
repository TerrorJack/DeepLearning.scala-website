#!/usr/bin/env bash

demo_data_path=_data/demo.yml
ipynbs_dir_name=${2:-"ipynbs"}
demo_dir_name=demo
root_absolute_path=${1:-$(pwd)}
git_dir_name=${3:-"deeplearning-website"}

git_absolute_path=${root_absolute_path}/${git_dir_name}
ipynbs_absolute_path=${root_absolute_path}/${ipynbs_dir_name}
demo_absolute_path=${git_absolute_path}/${demo_dir_name}


github_url=github.com/ThoughtWorksInc/DeepLearning.scala.git



git clone https://${github_url} --branch gh-pages ${git_absolute_path}



cp_file_and_restore_time() {
    execute_path=$1
    html_path=${demo_absolute_path}/${execute_path}
    ipynb_path=${ipynbs_absolute_path}/${execute_path}
    echo asdasdasdasd
    for FILE in ${execute_path}/*
    do
        if [[ -d $FILE ]]; then
            echo "$FILE is a directory"
            cp_file_and_restore_time $FILE
        elif [[ -f $FILE ]]; then
            echo "$FILE is a file"
        else
            echo "$FILE is not valid"
        fi
    done
    execute_path=$1
    html_path=${demo_absolute_path}/${execute_path}
    ipynb_path=${ipynbs_absolute_path}/${execute_path}
    echo "bash ${root_absolute_path}/restore_pushed_time.sh ${git_absolute_path} ${html_path} ${ipynb_path}"
    bash ${root_absolute_path}/restore_pushed_time.sh ${git_absolute_path} ${html_path} ${ipynb_path}
    cp -p ${html_path}/*.html ${ipynb_path}
    echo `(cd ${ipynb_path} && ls *.ipynb) | sed "s/.ipynb/.html/g"`  "MAKE_DIR=${root_absolute_path} GIT_DIR=${git_absolute_path} EXECUTE_PATH=${execute_path}" | xargs make -C ${ipynb_path} -f ${root_absolute_path}/Makefile
    echo `(cd ${ipynb_path} && ls *.ipynb) | sed "s/.ipynb/.html/g"`  "MAKE_DIR=${root_absolute_path} GIT_DIR=${git_absolute_path} EXECUTE_PATH=${execute_path}" | xargs echo "make -C ${ipynb_path} -f ${root_absolute_path}/Makefile"
    rm ${ipynb_path}/*.html
}

(cd ${ipynbs_absolute_path} && cp_file_and_restore_time .)

git config --global user.name "auto"
git config --global user.email "auto@thoughtworks.com"
git --git-dir=${git_absolute_path}/.git/ --work-tree=${git_absolute_path} commit -m "[auto] #001 auto generate the html from ipynb."
git --git-dir=${git_absolute_path}/.git/ --work-tree=${git_absolute_path}  push https://tw-data-china-go-cd:${GITHUB_ACCESS_TOKEN}@${github_url}> git_result 2> git_result
exit_code=$?
sed "s/${GITHUB_ACCESS_TOKEN}/**************/g" git_result

#rm -rf ${git_absolute_path}
rm git_result
rm ${ipynbs_absolute_path}/*.html
exit ${exit_code}
