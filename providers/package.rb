#
# Cookbook Name:: osx_zip
# Resource:: package
#
# Copyright 2011, Daniel Schauenberg
#

def load_current_resource
  @zippkg = Chef::Resource::OsxZipPackage.new(new_resource.name)
  @zippkg.app(new_resource.app)
  @zippkg.source(new_resource.source)
  @zippkg.checksum(new_resource.checksum)
  @zippkg.destination(new_resource.destination)
  Chef::Log.debug("Checking for application #{@zippkg.app}")
  installed = ::File.directory?("#{@zippkg.destination}/#{@zippkg.app}.app")
  @zippkg.installed(installed)
end

action :install do
  unless @zippkg.installed
  remote_file "#{Chef::Config[:file_cache_path]}/#{@zippkg.app}.zip" do
    source @zippkg.source
    checksum @zippkg.checksum
  end

  execute "untar #{@zippkg.app}.zip" do
    command "unzip #{Chef::Config[:file_cache_path]}/#{@zippkg.app}.zip"
    cwd @zippkg.destination
    not_if @zippkg.installed
  end

  directory "#{@zippkg.destination}/__MACOSX" do
    recursive true
    action :delete
  end

end

end
