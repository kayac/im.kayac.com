use Test::Base;
use Im::Test;

plan 'no_plan';

use Im::Models;
use Im::Form::Setting;
use CGI::Simple;

# reset
{
    my $user = models('Schema::User')->create({
        username => 'foo',
        password => 'foo',
    });
    $user->create_related('im', {});

    my $account = models('Schema::User')->single({ username => 'foo' })->im;
    my $initial = { $account->get_columns };
    $account->reset;

    is_deeply $initial, { $account->get_columns }, 'reset works ok';
}

my $account = models('Schema::User')->single({ username => 'foo' })->im;

# update_from_form with no authentication
{
    my $form = Im::Form::Setting->new(CGI::Simple->new({
        im      => 'jabber',
        account => 'example1@example.com',
        auth    => 'no',
    }));
    ok $form->submitted_and_valid, 'form is valid';

    $account->update_from_form($form);

    my $info =
        { models('Schema::User')->single({ username => 'foo' })->im->get_columns };

    delete @$info{qw/id validation_code/};

    is_deeply $info, {
        service             => 'jabber',
        username            => 'example1@example.com',
        authentication      => 'no',
        authentication_code => undef,
        valid               => 0,
    }, 'no authentication ok';
}

# update_from_form with password authentication
{
    my $form = Im::Form::Setting->new(CGI::Simple->new({
        im       => 'jabber',
        account  => 'example2@example.com',
        auth     => 'password',
        password => 'example_password',
    }));
    ok $form->submitted_and_valid, 'form is valid';

    $account->update_from_form($form);

    my $info =
        { models('Schema::User')->single({ username => 'foo' })->im->get_columns };

    delete @$info{qw/id validation_code/};

    is_deeply $info, {
        service             => 'jabber',
        username            => 'example2@example.com',
        authentication      => 'password',
        authentication_code => 'example_password',
        valid               => 0,
    }, 'password authentication ok';
}

# update_from_form with secret key authentication
{
    my $form = Im::Form::Setting->new(CGI::Simple->new({
        im        => 'jabber',
        account   => 'example3@example.com',
        auth      => 'secretkey',
        secretkey => 'example_secretkey',
    }));
    ok $form->submitted_and_valid, 'form is valid';

    $account->update_from_form($form);

    my $info =
        { models('Schema::User')->single({ username => 'foo' })->im->get_columns };

    delete @$info{qw/id validation_code/};

    is_deeply $info, {
        service             => 'jabber',
        username            => 'example3@example.com',
        authentication      => 'secretkey',
        authentication_code => 'example_secretkey',
        valid               => 0,
    }, 'secret key authentication ok';
}

# activate
{
    my $code = $account->validation_code;
    ok $code, 'validation_code is provied ok';

    ok !$account->activate('invalid_code'), 'activate return nothing when activate was failed ok';
    ok !$account->valid, 'acitivate failed ok';

    ok $account->activate($code), 'activate return true if activate was successful ok';
    ok $account->valid, 'acitivate success';
}

# change auth_type without account change
{
    is $account->authentication, 'secretkey', 'now secretkey auth ok';
    my $form = Im::Form::Setting->new(CGI::Simple->new({
        im        => $account->service,
        account   => $account->username,
        auth      => 'no',
    }));
    ok $form->submitted_and_valid, 'form is valid';

    $account->update_from_form($form);

    $account = models('Schema::User')->single({ username => 'foo' })->im;

    is $account->authentication, 'no', 'now no auth type ok';
    ok $account->valid, 'account stil valid ok';
}

# change account then require activate again
{
    my $form = Im::Form::Setting->new(CGI::Simple->new({
        im        => $account->service,
        account   => 'example99@example.com',
        auth      => 'no',
    }));

    ok $account->valid, 'account valid ok';

    $account->update_from_form( $form );

    ok !$account->valid, 'account now invalid';
}
