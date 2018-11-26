package Synthesizer::PitchModulator {

  use Moo::Role;
  use utf8;
  use Types::Standard qw( :types );
  use Type::Utils qw( class_type );
  use Function::Parameters qw( :std :modifiers );
  use Function::Return;

  has depth => (
    is       => 'ro',
    isa      => Num,
    required => 1,
  );

  requires 'calc_modulator';

  around calc_modulator() :Return(Num) {}

  method calc() :Return(Num) {
    $self->calc_modulator * $self->depth;
  }

}

1;
