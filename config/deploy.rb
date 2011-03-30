# Qual o nome da nossa aplicacao local ?
set :application, "cloud-k.dev"

# Qual o utilizador que se conecta ao servidor remoto?
set :user, "nuvemk"

# Onde está localizado o repositório ?
set :repository, "git@github.com:oikram/cloud-k.dev.git"

# Qual o domínio do teu servidor de produção ?
role :web, "dev.cloud-k.pt"

# Qual a directoria remota que aloja o site?
set :deploy_to, "/home/nuvemk/webapps/dev/"

# O comando sudo é necessário para manipular os ficheiros no servidor remoto?
set :use_sudo, false

# Que controlo de versão usamos no projeto?
set :scm, :git
set :branch, 'master'

# Password para fazer um deploy usando comandos git
set :scm_passphrase, "alcap0ne"  

# Como vão ser transferidos os ficheiros do projeto?
# O deploy via :copy, fará com que o Capistrano clone o repositório, arquive-oe comprima-o e, depois, o transfira para o servidor remoto. Um modo mais eficiente do que o :copy seria o :remote_cache que faria o capistrano colocar apenas os últimos commits, em vez de transferir o projeto inteiro mas, para tal, o git teria de estar instalado no servidor.
#set :deploy_via, :copy
set :deploy_via, :remote_cache

# Manter a cache do repositório local para acelarar o processo?
# Isto fará o Capistrano colocar em /tmp a cache do projeto.
#set :copy_cache, true


# Ignorar algum tipo de ficheiro específico aquando do envio para produção?
#set :copy_exclude, %w(.git)

# Criar uma task (chamada create_symlinks) que remova o /public/.htaccess que veio do nosso ambiente de desenvolvimento e que tem a seguinte instrução: SetEnv APPLICATION_ENV development e, mudamos por um outro (que estará numa pasta production, e que terá: SetEnv APPLICATION_ENV production

task :create_symlinks, :roles => :web do
run "rm #{current_release}/public/.htaccess"
run "ln -s #{current_release}/production/.htaccess
#{current_release}/public/.htaccess"
end

# Depois do deployment ter terminado com sucesso, chamos a nossa task (create_symlinks):
after "deploy:finalize_update", :create_symlinks
