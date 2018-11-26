package Synthesizer::Wave::Pulse {

  use Moo;
  use Types::Standard qw( :types );
  use Function::Parameters qw( :std );
  use Function::Return;

  with 'Synthesizer::Wave::Wave';

  method calc($param) :Return(Num) {
    ($param < 0.5) ? -1.0 : 1.0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

矩形波クラス
