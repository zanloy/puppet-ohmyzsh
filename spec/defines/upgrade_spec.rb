require 'spec_helper'

testcases = {
  'user1' => '/home/user1',
  'root' => '/root',
}

describe 'ohmyzsh::upgrade' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      testcases.each do |user, home|
        context "using case #{user}" do
          let(:title) { user }
          it do
            should contain_exec("ohmyzsh::git upgrade #{user}")
              .with_command('git pull --rebase --stat origin master')
              .with_cwd("#{home}/.oh-my-zsh")
              .with_user(user)
          end
        end
      end
    end
  end
end
