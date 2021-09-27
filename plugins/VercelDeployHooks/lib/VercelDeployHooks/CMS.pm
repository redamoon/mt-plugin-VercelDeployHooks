package VercelDeployHooks::CMS;
use strict;

use MT;
use HTTP::Request::Common;
use JSON;

use VercelDeployHooks::Util qw( plugin instance request doLog );


# 設定一覧
sub setting {
    my $app = shift;
    my $plugin = plugin();
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id;
    $app->add_breadcrumb($plugin->translate('Vercel Deploy Hooks Plugin'));
    my %param = (
        vercel_deploy_hooks_production => $plugin->get_config_value('vercel_deploy_hooks_production', 'blog:' . $blog_id),
        vercel_deploy_hooks_develop    => $plugin->get_config_value('vercel_deploy_hooks_develop', 'blog:' . $blog_id),
        preview_url                    => $plugin->get_config_value('preview_url', 'blog:' . $blog_id),
        blog_path                      => $plugin->get_config_value('blog_path', 'blog', $blog_id)
    );
    return instance->load_tmpl('vercel_deploy.tmpl', \%param);
}

# 本番サイトを保存する
sub production {
    my $app = shift;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id;
    request('vercel_deploy_hooks_production', $blog_id, 'save_production', $app, 'error_production');
    $app->call_return;
}

# 開発サイトを保存する
sub develop {
    my $app = shift;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id;
    request('vercel_deploy_hooks_develop', $blog_id, 'save_develop', $app, 'error_develop');
    $app->call_return;
}

# プレビューURLを保存する
sub preview {
    my $app = shift;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id;
    request('preview_url', $blog_id, 'save_preview', $app, 'error_preview');
    $app->call_return;
}

# ブログパスを保存する
sub blog_path {
    my $app = shift;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id;
    request('blog_path', $blog_id, 'save_path', $app, 'error_path');
    $app->call_return;
}

1
