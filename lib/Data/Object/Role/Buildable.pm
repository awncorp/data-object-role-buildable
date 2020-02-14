package Data::Object::Role::Buildable;

use 5.014;

use Moo::Role;

sub BUILD {

  return $_[0];
}

around BUILD => sub {
  my ($orig, $self, $args) = @_;

  if ($self->can('build_self')) {
    $self->build_self($args);
  }

  return $self;
};

around BUILDARGS => sub {
  my ($orig, $class, @args) = @_;

  # build_arg accepts a single-arg (non-hash)
  my $inflate = @args == 1 && ref $args[0] ne 'HASH';

  # single argument
  if ($class->can('build_arg') && $inflate) {
    @args = ($class->build_arg($args[0]));
  }

  # build_args should not accept a single-arg (non-hash)
  my $ignore = @args == 1 && ref $args[0] ne 'HASH';

  # standard arguments
  if ($class->can('build_args') && !$ignore) {
    @args = ($class->build_args(@args == 1 ? $args[0] : {@args}));
  }

  return $class->$orig(@args);
};

1;
