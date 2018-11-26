package Synthesizer::Envelope {

  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Type::Utils qw( class_type );
  use Function::Parameters qw( :std );
  use Function::Return;

  use Synthesizer::Wave::Envelope;

  has sec => (
    is       => 'ro',
    isa      => Num,
    required => 1,
  );

  has samples_per_sec => (
    is      => 'ro',
    isa     => Int,
    default => 44100,
  );

  has curve => (
    is      => 'ro',
    isa     => Num,
    default => 1.0,
  );

  has wave => (
    is      => 'ro',
    isa     => class_type(+{ class => 'Synthesizer::Wave::Envelope' }),
    builder => '_build_wave',
  );

  has interval => (
    is      => 'ro',
    isa     => Num,
    lazy    => 1,
    builder => '_build_interval',
  );

  has _t => (
    is      => 'rw',
    isa     => Num,
    default => 0.0,
  );

  method _build_wave() :Return(class_type +{ class => 'Synthesizer::Wave::Envelope' }) {
    Synthesizer::Wave::Envelope->new;
  }

  method _build_interval() :Return(Num) {
    $self->samples_per_sec * $self->sec;
  }

  method calc() :Return(Num) {
    my $t = $self->_t;
    if ( $t < $self->interval ) {
      my $ret = $self->wave->calc( $t / $self->interval );
      $t += 1.0;
      $self->_t($t);
      $ret ** $self->curve;
    }
    else {
      0.0;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;
