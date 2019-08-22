git pull origin master
bundle install
jekyll build
cp -r _site/. ../twdc_blog
cd ../twdc_blog
git add -A
git commit -m "Auto Deploy"
git pull origin master
git push origin master


