package Synthesizer::Oscillator {

  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Type::Utils qw( class_type role_type );
  use Function::Parameters qw( :std );
  use Function::Return;

  has frequency => (
    is       => 'ro',
    isa      => class_type(+{ class => 'Synthesizer::Frequency' }),
    required => 1,
  );

  has wave => (
    is       => 'ro',
    isa      => role_type(+{ role => 'Synthesizer::Wave::Wave' }),
    required => 1,
  );

  has samples_per_sec => (
    is      => 'ro',
    isa     => Int,
    default => 44100,
  );

  has _t => (
    is      => 'rw',
    isa     => Num,
    default => 0.0,
  );

  has samples_per_cycle => (
    is      => 'ro',
    isa     => Num,
    lazy    => 1,
    builder => '_build_samples_per_cycle',
  );

  method _build_samples_per_cycle() :Return(Num) {
    $self->samples_per_sec / $self->frequency;
  }

  method calc($mod) :Return(Num) {
    my $t   = $self->_t;
    my $ret = $self->wave->calc( $t / $self->samples_per_cycle );
    my $dt  = 1.0 + $mod;
    if ( 0.0 < $dt ) {
      $t += $dt;
      $t -= $self->samples_per_cycle * int( $t / $self->samples_per_cycle );
    }
    $self->_t($t);
    $ret;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__


オシレータークラス
基礎となる音色的な
