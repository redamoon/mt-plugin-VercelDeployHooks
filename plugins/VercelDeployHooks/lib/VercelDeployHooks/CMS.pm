package VercelDeployHooks::CMS;
use strict;

use MT;

use constant VercelDeployHooksUrl => 'https://api.vercel.com/v1/integrations/deploy/';
use HTTP::Request::Common;
use JSON;

sub plugin {
    return MT->component('VercelDeployHooks');
}
sub instance { MT->instance->component('VercelDeployHooks'); }

sub request {
    my ($key, $blog_id, $save_name, $app, $error_name) = @_;
    require MT::Util::Log;
    MT::Util::Log->init();
    my $plugin = plugin();
    my $app_id = $plugin->get_config_value($key, 'blog:' . $blog_id);
    MT::Util::Log->info('VercelDeployHooks: no app_id') unless $app_id;
    return unless $app_id;

    # webhook url
    my $url = VercelDeployHooksUrl . $app_id;
    my $ua = MT->new_ua( { timeout => 10 } );
    return unless $ua;
    my $request = POST($url, Content_Type => 'application/json', Content => encode_json({}));
    my $response = $ua->request($request);

    if ($response->code == 201) {
        $app->add_return_arg($save_name => 1),
    } else {
        $app->add_return_arg($error_name => 1)
    };
    return unless $response->is_success();
    return 1;
}

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
        vercel_deploy_hooks_develop    => $plugin->get_config_value('vercel_deploy_hooks_develop', 'blog:' . $blog_id)
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

1
