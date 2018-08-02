require 'spec_helper'

describe 'ohmyzsh::fetch::theme' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'fetch a theme' do
        let(:pre_condition) { "ohmyzsh::install { 'user1': }" }
        let(:title) { 'user1' }
        let(:params) { { user: 'user1', filename: 'squared.zsh-theme' } } 
        context 'with a url' do
          let(:params) { super().merge({url: 'http://zanloy.com/files/dotfiles/oh-my-zsh/squared.zsh-theme'}) } 
          it do
            should contain_wget__fetch('ohmyzsh::fetch-user1-squared.zsh-theme')
              .with_source('http://zanloy.com/files/dotfiles/oh-my-zsh/squared.zsh-theme')
              .with_destination('/home/user1/.oh-my-zsh/custom/themes/squared.zsh-theme')
              .with_user('user1')
          end
        end
        context 'with a source' do
          let(:params) { super().merge({source: 'puppet:///modules/ohmyzsh/squared.zsh-theme'}) }
          it do
            should contain_file('/home/user1/.oh-my-zsh/custom/themes/squared.zsh-theme')
              .with_source('puppet:///modules/ohmyzsh/squared.zsh-theme')
              .with_owner('user1')
          end
        end
        context 'with content' do
          let(:params) { super().merge({content: 'This is a badass new zsh theme.'}) }
          it do
            should contain_file('/home/user1/.oh-my-zsh/custom/themes/squared.zsh-theme')
              .with_content('This is a badass new zsh theme.')
              .with_owner('user1')
          end
        end
      end
      context 'with root user' do
        let(:pre_condition) { "ohmyzsh::install { 'root': }" }
        let(:title) { 'root' }
        let(:params) { { user: 'root', filename: 'squared.zsh-theme', content: 'This is a badass new zsh theme.'} }
        context 'with content' do
          it do
            should contain_file('/root/.oh-my-zsh/custom/themes/squared.zsh-theme')
              .with_content('This is a badass new zsh theme.')
              .with_owner('root')
          end
        end
      end
      context 'generate errors' do
        context 'without $url, $source, or $content' do
          let(:title) { 'errored' }
          let(:params) { { user: 'root', filename: 'squared.zsh-theme'} }
          it { expect { should compile }.to raise_error RSpec::Expectations::ExpectationNotMetError }
        end
      end
    end
  end
end
