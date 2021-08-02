package VercelDeployHooks::L10N::ja;

use strict;
use base 'VercelDeployHooks::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Production'                                                          => '本番',
    'Develop'                                                             => '開発',
    'The POST request failed.'                                            => 'POSTリクエストに失敗しました。',
    'Production ID'                                                       => '本番環境 ID',
    'Develop ID'                                                          => '開発環境 ID',
    'Production build'                                                    => '本番ビルド',
    'Develop build'                                                       => '開発ビルド',
    'Build'                                                               => 'ビルドする',
    'I ran a development build of Vercel.'                               => 'Vercelの開発ビルドを実行しました。',
    'I ran a production build of Vercel.'                                => 'Vercelの本番ビルドを実行しました。',
    'No Vercel build hooks are defined.'                              => 'Vercelビルドフックは定義されていません。',
    'Enter your Vercel Deploy Hooks ID for your development environment.' => '開発環境のVercel Deploy Hooks IDを入力してください。',
    'Enter your production Vercel Deploy Hooks ID.'                       => '本番環境のVercel Deploy Hooks IDを入力してください。',
    'Vercel Deploy Hooks Plugin'                                          => 'Vercel Deploy Hooks',
    '_PLUGIN_DESCRIPTION'                                                 => 'Vercel Deploy Hooksを実行する',
    '_PLUGIN_AUTHOR'                                                      => 'redamoon',
);

1;
