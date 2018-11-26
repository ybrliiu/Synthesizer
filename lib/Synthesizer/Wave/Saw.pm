package Synthesizer::Wave::Saw {

  use Moo;
  use Types::Standard qw( :types );
  use Function::Parameters qw( :std );
  use Function::Return;

  with 'Synthesizer::Wave::Wave';

  method calc($param) :Return(Num) {
    2.0 * $param - 1.0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

のこぎり波クラス
