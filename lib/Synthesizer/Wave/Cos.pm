package Synthesizer::Wave::Cos {

  use Moo;
  use Types::Standard qw( :types );
  use Function::Parameters qw( :std );
  use Function::Return;

  use Math::Trig qw( pi );

  with 'Synthesizer::Wave::Wave';

  method calc($param) :Return(Num) {
    cos( 2.0 * pi * $param );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

cos波クラス
