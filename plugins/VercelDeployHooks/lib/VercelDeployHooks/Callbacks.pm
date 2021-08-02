package VercelDeployHooks::Callbacks;
use strict;

use MT;

use VercelDeployHooks::Util qw( plugin instance request doLog );
use MT::EntryStatus qw(:all);

# 記事の保存時
sub post_save_entry {
    my $app = MT->instance;
    my $blog_id = $app->param('blog_id');
    my ($cb, $a, $obj, $org_obj) = @_;
    my $status = status_text($obj->status);
    doLog($status);
    unless ($status eq 'Draft') {
        request('vercel_deploy_hooks_production', $blog_id, 'save_production', $app, 'error_production');
    }
    $app->call_return;
}

1;
