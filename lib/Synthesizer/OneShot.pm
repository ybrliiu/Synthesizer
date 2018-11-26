package Synthesizer::OneShot {

  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Type::Utils qw( class_type role_type );
  use Function::Parameters qw( :std :modifiers );
  use Function::Return;

  extends 'Synthesizer::Sound';

  has envelope => (
    is       => 'ro',
    isa      => class_type(+{ class => 'Synthesizer::Envelope' }),
    required => 1,
  );

  has '+sec' => (
    required => 0,
    lazy     => 1,
    builder  => '_build_sec',
  );

  method _build_sec() :Return(Num) {
    $self->envelope->calc;
  }

  around _build_data() :Return(ArrayRef[Num]) {
    [ map { $self->calc_oscillator() * $self->envelope->calc() } 1 .. $self->data_num() ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;
