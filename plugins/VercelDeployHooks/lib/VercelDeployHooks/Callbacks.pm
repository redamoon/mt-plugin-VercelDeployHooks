package VercelDeployHooks::Callbacks;
use strict;

use MT;

use VercelDeployHooks::Util qw( plugin instance request doLog );

# 記事の保存時
sub post_save_entry {
    my $app = MT->instance;
    my $blog_id = $app->param('blog_id');
    doLog($blog_id);
    request('vercel_deploy_hooks_production', $blog_id, 'save_production', $app, 'error_production');
    $app->call_return;
}

1;
