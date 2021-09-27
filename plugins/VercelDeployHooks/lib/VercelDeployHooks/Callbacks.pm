package VercelDeployHooks::Callbacks;
use strict;
use MT;

use VercelDeployHooks::Util qw( plugin instance request doLog );
use MT::EntryStatus qw(:all);

# 記事の公開時
sub post_save_entry {
    my $app = MT->instance;
    my $blog_id = $app->param('blog_id');
    my ($cb, $a, $obj, $org_obj) = @_;
    my $status = status_text($obj->status);
    unless ($status eq 'Draft') {
        request('vercel_deploy_hooks_production', $blog_id, 'save_production', $app, 'error_production');
    }
    $app->call_return;
}

# 記事のプレビュー時
sub post_preview_entry {
    my $instance = MT->instance;
    my $blog_id = $instance->param('blog_id');
    my $plugin = plugin();

    my ($cd, $app, $obj, $orig_obj) = @_;
    my $q = $app->param;
    my $entry_id = $q->param('id');
    my $preview_url = $plugin->get_config_value('preview_url', 'blog:' . $blog_id);
    my $path = $plugin->get_config_value('blog_path', 'blog:' . $blog_id);
    my $author = $app->user->name;
    my $password = $app->user->api_password;
    return $instance->redirect($preview_url . '?path=' . $path . $entry_id . '&user=' . $author . '&pass=' . $password)
}

1;
