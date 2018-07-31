if [ "x${TRAVIS_REPO_SLUG}" = "xdumasl/SIRIUS" ]; then
    openssl aes-256-cbc -K $encrypted_0e11fa39d04b_key -iv $encrypted_0e11fa39d04b_iv -in .travis/github_deploy_key.enc -out github_deploy_key -d
    chmod 600 github_deploy_key
    eval `ssh-agent -s`
    ssh-add github_deploy_key

    cd "$TRAVIS_BUILD_DIR"
    mkdir doc/sphinx/build
    docker run -v $TRAVIS_BUILD_DIR/doc/sphinx:/sphinx ldumas/sirius_dockerfile:sirius_pages /bin/sh -c "cd /sphinx; make html"
    docker run -v $TRAVIS_BUILD_DIR:/data ldumas/sirius_dockerfile:sirius_pages /bin/sh -c "cd /data; mv doxy_html doc/sphinx/build/"
    cd $TRAVIS_BUILD_DIR/doc/sphinx/build/
    touch .nojekyll
    git init
    git checkout -b gh-pages
    git add .
    git -c user.name='travis' -c user.email='travis' commit -m init
    git push -f git@github.com:${TRAVIS_REPO_SLUG}.git gh-pages
    cd "$TRAVIS_BUILD_DIR"
fi

