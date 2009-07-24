package Im::API;
use Any::Moose;

extends any_moose('::Object'), 'Class::ErrorHandler';

__PACKAGE__->meta->make_immutable;
