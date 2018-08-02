require 'spec_helper'

testcases = {
  'user1' => {
    params: { },
    expect: { home: '/home/user1', sh: false }
  },
  'user2' => {
    params: { set_sh: true, disable_auto_update: true },
    expect: { home: '/home/user2', sh: true, disable_auto_update: true }
  },
  'root' => {
    params: { },
    expect: { home: '/root', sh: false }
  },
}

describe 'ohmyzsh::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      case facts[:osfamily]
      when 'RedHat'
        valid_sh = '/bin/zsh'
      else
        valid_sh = '/usr/bin/zsh'
      end

      testcases.each do |user, values|
        context "testing #{user}" do
          let(:title) { user }
          let(:params) { values[:params] }
          it do
            should contain_exec("ohmyzsh::git clone #{user}")
              .with_creates("#{values[:expect][:home]}/.oh-my-zsh")
              .with_command("git clone https://github.com/robbyrussell/oh-my-zsh.git #{values[:expect][:home]}/.oh-my-zsh || (rmdir #{values[:expect][:home]}/.oh-my-zsh && exit 1)")
              .with_user(user)
          end
          it do
            should contain_exec("ohmyzsh::cp .zshrc #{user}")
              .with_creates("#{values[:expect][:home]}/.zshrc")
              .with_command("cp #{values[:expect][:home]}/.oh-my-zsh/templates/zshrc.zsh-template #{values[:expect][:home]}/.zshrc")
              .with_user(user)
          end
          if values[:expect][:sh]
            it do
              should contain_user("ohmyzsh::user #{user}")
                .with_name(user)
                .with_shell(valid_sh)
            end
          end
          if values[:expect][:disable_auto_update]
            it do
              should contain_file_line("ohmyzsh::disable_auto_update #{user}")
                .with_path("#{values[:expect][:home]}/.zshrc")
                .with_line('DISABLE_AUTO_UPDATE="true"')
            end
          else
            it do
              should contain_file_line("ohmyzsh::disable_auto_update #{user}")
                .with_path("#{values[:expect][:home]}/.zshrc")
                .with_line('DISABLE_AUTO_UPDATE="false"')
            end
          end
        end
      end
    end
  end #testcases.each
end #describe
