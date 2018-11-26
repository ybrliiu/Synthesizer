package Synthesizer::Wave::Tri {

  use Moo;
  use Types::Standard qw( :types );
  use Function::Parameters qw( :std );
  use Function::Return;

  with 'Synthesizer::Wave::Wave';

  method calc($param) :Return(Num) {
    if ( $param < 0.5 ) {
      # -1.0 -> +1.0
      -1.0 + 4.0 * $param;
    }
    else {
      # +1.0 -> -1.0
      1.0 - ( 4.0 * ( $param - 0.5 ) );
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

三角波クラス
