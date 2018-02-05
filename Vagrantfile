# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'fileutils'

module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

# ===========================         Настройка Vagrant        ==================================
# Проверяем необходимые плагины
required_plugins = %w( vagrant-vbguest vagrant-cachier )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

# Проверка системы хоста
if OS.linux?
    ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
elsif OS.windows?
    required_plugins = %w( vagrant-winnfsd )
    required_plugins.each do |plugin|
        exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
    end
    ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
elsif OS.mac?
    required_plugins = %w( vagrant-parallels )
    required_plugins.each do |plugin|
        exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
    end
    ENV['VAGRANT_DEFAULT_PROVIDER'] = 'parallels'

end

# ===========================        Подгрузка конфигов        ==================================
# Базовые переменные
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Пути к конфигам
config = {
  local: './provision/config/vagrant-local.yml',
  example: './provision/config/vagrant-local.example.yml'
}

# Копируем конфиг их примера, если локального не существует
FileUtils.cp config[:example], config[:local] unless File.exist?(config[:local])
# Читаем конфиг
options = YAML.load_file config[:local]

# Проверка системы хоста
if OS.linux?
    #Linux
    host_ip = 'localhost'
else
    host_ip = options['ip']
end
# ===========================       Организация конфигов       ==================================

# Микросервисы проекта
project_structure = {
    api: {
        name: "api",
        path: "./api/",
        port: 8001,
    },
    backend: {
        name: "backend",
        path: "./backend/",
        port: 8002,
    },
    frontend: {
        name: "frontend",
        path: "./frontend/",
        port: 8003,
    }
}

# Модули для управления микросервисами
manage_modules  = {
    doc: './doc/'
}

# ===========================       Vagrant-конфигурация       ==================================
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # ---------------------------       Общие настройки      ---------------------------
    config.vm.synced_folder ".", "/vagrant", disabled: true
    # config.ssh.port = "22"
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant"
    # ---------------------------    Микросервисы проекта    ---------------------------
    # Frontend
    config.vm.define :frontend do |frontend|
        frontend.vm.provider :docker do |d|
            # Директория
            d.build_dir = project_structure[:frontend][:path]
            # Название контейнера
            d.name = "#{project_structure[:frontend][:name]}_#{options['project_name']}"
            # Название образа
            d.build_args = ["-t=#{project_structure[:frontend][:name]}_#{options['project_name']}"]
            # Добавляем возможность подключиться к контейнеру по SSH
            d.has_ssh = true
            # Проброс портов
            d.ports = [
                # Рабочий порт
                "#{project_structure[:frontend][:port]}:8080"
            ]
            # Чтобы контейнер работал всегда, пока работает vagrant
            d.remains_running = true
            # Если нужна VM
            d.vagrant_vagrantfile = "./provision/vm/Vagrantfile"
            d.vagrant_machine = "#{options['project_name']}_dockerhost"
        end
    end

    # # Backend
    # config.vm.define :backend do |backend|
    #     # Настройка провайдера
    #     backend.vm.provider :docker do |d|
    #         # Директория
    #         d.build_dir = project_structure[:backend][:path]
    #         # Название контейнера
    #         d.name = "#{project_structure[:backend][:name]}_#{options['project_name']}"
    #         # Название образа
    #         d.build_args = ["-t=#{project_structure[:backend][:name]}_#{options['project_name']}"]
    #         # Проброс портов
    #         d.ports = ["#{project_structure[:backend][:port]}:8080"]
    #         # Чтобы контейнер работал всегда, пока работает vagrant
    #         d.remains_running = false
    #         # Если нужна VM
    #         d.vagrant_vagrantfile = "./provision/vm/Vagrantfile"
    #         d.vagrant_machine = "#{options['project_name']}_dockerhost"
    #     end
    # end

end
