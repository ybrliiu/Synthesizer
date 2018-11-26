package Synthesizer::Filter {

  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Type::Utils qw( class_type );
  use Function::Parameters qw( :std );
  use Function::Return;

  with 'Synthesizer::PitchModulator';

  has oscillator => (
    is       => 'ro',
    isa      => class_type(+{ class => 'Synthesizer::Oscillator' }),
    required => 1,
  );

  method calc_modulator() :Return(Num) {
    $self->oscillator->calc(0);
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

https://www.g200kg.com/jp/docs/dic/filter.html
