package Synthesizer::Wave::Wave {

  use Moo::Role;
  use Types::Standard qw( :types );
  use Function::Parameters qw( :modifiers );
  use Function::Return;

  requires 'calc';

  around calc($param) :Return(Num) {
    $self->$orig();
  }

}

1;

__END__

波形クラス
