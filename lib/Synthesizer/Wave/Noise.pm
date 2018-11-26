package Synthesizer::Wave::Noise {

  use Moo;
  use Types::Standard qw( :types );
  use Function::Parameters qw( :std );
  use Function::Return;

  with 'Synthesizer::Wave::Wave';

  my $noise = do {
    # 好みの音が得られるよう, randのシードを固定する
    srand(2);
    my @noise = map { rand(2) - 1 } 1 .. 1024;
    srand();
    \@noise;
  };

  method calc($param) :Return(Num) {
    $param < 1 ? $noise->[ int( $param * @$noise ) ] : 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

ノイズクラス
