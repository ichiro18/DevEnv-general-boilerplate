# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'fileutils'


# Проверяем необходимые плагины
required_plugins = %w( vagrant-hostsupdater vagrant-vbguest vagrant-cachier )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

# Используемые домены
domains = {
  frontend: 'frontend-ops.dev',
  backend:  'backend-ops.dev'
}


# Пути к конфигам
config = {
  local: './vagrant/config/vagrant-local.yml',
  example: './vagrant/config/vagrant-local.example.yml'
}

# Копируем конфиг их примера, если локального не существует
FileUtils.cp config[:example], config[:local] unless File.exist?(config[:local])
# Читаем конфиг
options = YAML.load_file config[:local]

# Проверяем github token
if options['github_token'].nil? || options['github_token'].to_s.length != 40
  puts "You must place REAL GitHub token into configuration:\n/Projectdir/vagrant/config/vagrant-local.yml"
  exit
end

# vagrant конфигурация
Vagrant.configure("2") do |config|
  # Выбираем образ системы
  config.vm.box = "centos/7"

  # Кэширование обновлений
  config.cache.scope = :box

  # Автообновление плагинов для VirtualBox
  config.vbguest.auto_update = false

  # Автообновление системы
  config.vm.box_check_update = options['box_check_update']

  config.vm.provider 'virtualbox' do |vb|
    # Количество ядер процессора
    vb.cpus = options['cpus']
    # Размер оперативной памяти
    vb.memory = options['memory']
    # Имя виртуальной машины
    vb.name = options['machine_name']
  end

  # Имя виртуальной машины (для консоли Vagrant)
  config.vm.define options['machine_name']

  # Имя виртуальной машины (для консоли guest machine)
  config.vm.hostname = options['machine_name']

  # Сетевые настройки
  config.vm.network 'private_network', ip: options['ip']

  # Настройки хостов (host machine)
  config.hostsupdater.aliases            = domains.values

  # Исполняемые скрипты на guest machine
  config.vm.provision 'shell', path: './vagrant/provision/once-as-root.sh', args: [options['timezone']]
  config.vm.provision 'shell', path: './vagrant/provision/once-as-vagrant.sh', args: [options['github_token']], privileged: false
  # config.vm.provision 'shell', path: './vagrant/provision/always-as-root.sh', run: 'always'
  config.vm.provision 'shell', path: './vagrant/provision/always-as-vagrant.sh', run: 'always'


  # Синхронизация файлов 'Папка проекта' (host machine) -> папка '/app' (guest machine)
  config.vm.synced_folder './', '/GO/src/App/', owner: 'vagrant', group: 'vagrant'

  # Исключаем папку '/vagrant' (guest machine) из расшаривания
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Сообщение после установки (vagrant console)
  config.vm.post_up_message = "Guest machine #{options[:machine_name]} DONE!\n Frontend URL: http://#{domains[:frontend]}\nBackend URL: http://#{domains[:backend]}"

end
