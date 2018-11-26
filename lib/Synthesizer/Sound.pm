package Synthesizer::Sound {

  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Type::Utils qw( class_type role_type );
  use Function::Parameters qw( :std );
  use Function::Return;

  has sec => (
    is       => 'ro',
    isa      => Num,
    required => 1,
  );

  has oscillator => (
    is       => 'ro',
    isa      => class_type(+{ class => 'Synthesizer::Oscillator' }),
    required => 1,
  );

  has samples_per_sec => (
    is      => 'ro',
    isa     => Int,
    default => 44100,
  );

  has maybe_pitch_modulator => (
    is      => 'ro',
    isa     => Maybe[ role_type +{ role => 'Synthesizer::PitchModulator' } ],
    default => undef,
  );

  has data => (
    is      => 'ro',
    isa     => ArrayRef[Num],
    lazy    => 1,
    builder => '_build_data',
  );

  method data_num() :Return(Int) {
    int( $self->samples_per_sec * $self->sec );
  }

  method calc_oscillator() :Return(Num) {
    my $mod = defined $self->maybe_pitch_modulator ? $self->maybe_pitch_modulator->calc() : 0;
    $self->oscillator->calc($mod);
  }

  method _build_data() :Return(ArrayRef[Num]) {
    [ map { $self->calc_oscillator() } 1 .. $self->data_num() ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__
