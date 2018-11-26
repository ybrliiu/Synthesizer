package Synthesizer::Wave::Envelope {

  use Moo;
  use Types::Standard qw( :types );
  use Function::Parameters qw( :std );
  use Function::Return;

  with 'Synthesizer::Wave::Wave';

  method calc($param) :Return(Num) {
    1.0 - $param;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

減衰音波形クラス
