package Synthesizer::PitchEnvelope {

  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Type::Utils qw( class_type );
  use Function::Parameters qw( :std );
  use Function::Return;

  with 'Synthesizer::PitchModulator';

  has envelope => (
    is       => 'ro',
    isa      => class_type(+{ class => 'Synthesizer::Envelope' }),
    required => 1,
  );

  method calc_modulator() :Return(Num) {
    $self->envelope->calc();
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

https://www.g200kg.com/jp/docs/dic/envelope.html
ピッチ・エンベロープ
