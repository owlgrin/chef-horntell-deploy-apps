git '/home/ubuntu/apps/apps' do
	repository 'gitlab@gitlab.owlgrin.com:horntell/apps.git'
	revision 'master'
	action :sync
end

composer_project '/home/ubuntu/apps/apps' do
	action :install
end

# making storage is important, otherwise pages will not load
execute "Making '/home/ubuntu/apps/apps' storage writable" do
	command "sudo chmod -R a+w /home/ubuntu/apps/apps/app/storage"
end

# the production configs will come from another private repo
git "/home/ubuntu/apps/apps/app/config/production" do
	repository 'gitlab@gitlab.owlgrin.com:horntell/configs.git'
	revision 'apps'
	action :sync
end

# move the .env file to the root of project
remote_file "Copy .env.production file" do 
  path "/home/ubuntu/apps/apps/.env.php" 
  source "file:///home/ubuntu/apps/apps/app/config/production/.env.production.php"
  owner 'ubuntu'
  group 'ubuntu'
  mode 0755
end