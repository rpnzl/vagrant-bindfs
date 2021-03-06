# frozen_string_literal: true
module VagrantBindfs
  module Vagrant
    module Capabilities
      module Debian
        module Bindfs
          class << self
            def bindfs_bindfs_install(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('apt-get install -y bindfs')
            end

            def bindfs_bindfs_search_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.tap do |comm|
                comm.sudo("aptitude versions bindfs | sed -n '/p/,${p}' | sed 's/\s\+/ /g' | cut -d' ' -f2") do |_, output|
                  package_version = output.strip
                  return "bindfs-#{package_version}" if !package_version.empty? && !package_version.match(/^#{version}/).nil?
                end
              end
              false
            end

            def bindfs_bindfs_install_version(machine, version)
              machine.guest.capability(:bindfs_package_manager_update)
              package_version = machine.guest.capability(:bindfs_bindfs_search_version, version)
              machine.communicate.sudo("apt-get install -y bindfs=#{package_version.shellescape}")
            end

            def bindfs_bindfs_install_compilation_requirements(machine)
              machine.guest.capability(:bindfs_package_manager_update)
              machine.communicate.sudo('apt-get install -y build-essential pkg-config wget tar libfuse-dev')
            end
          end
        end
      end
    end
  end
end
