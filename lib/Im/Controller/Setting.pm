package Im::Controller::Setting;
use Ark '+Im::Controller::RequireSignin';
use Im::Models;

with 'Ark::ActionClass::Form';

sub index :Path {
    my ($self, $c) = @_;

    my $im_setting = $c->stash->{im_setting} = $c->user->obj->im;

    if ($c->req->method eq 'POST' and $c->req->param('reset')) {
        $c->forward('reset');
    }
    elsif ( !$im_setting->valid && $im_setting->validation_code ) {
        $c->forward('activate');
    }
    else {
        $c->forward('setting');
    }
}

sub setting :Private :Form('Im::Form::Setting') {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST') {
        $c->forward('setting_post');
    }
    else {
        my $im_setting = $c->stash->{im_setting};

        $self->form->fill(
            im      => $im_setting->service,
            account => $im_setting->username,
            auth    => $im_setting->authentication,
        );
    }
}

sub setting_post :Private {
    my ($self, $c) = @_;

    if ($self->form->submitted_and_valid) {
        my $setting = $c->stash->{im_setting}->update_from_form($self->form);

        unless ($setting->valid) {
            # show validation code
            $c->redirect_and_detach( $c->uri_for('/setting/') );
        }

        $c->stash->{flash_message} = $c->localize('Setting has been updated');
    }
}

sub activate :Private :Form('Im::Form::Setting::Activate') {
    my ($self, $c) = @_;

    $self->form->fill(
        code => $c->stash->{im_setting}->validation_code,
    );
    $c->view('MT')->template('setting/activate');
}

sub reset :Private {
    my ($self, $c) = @_;

    $c->user->obj->im->reset;
    $c->redirect_and_detach( $c->uri_for('/setting/') );
}

1;
