class TipoPersona {
  TipoPersona({required this.nTypePerson, required this.sNamePerson});
  late int nTypePerson;
  late String sNamePerson;

  List<TipoPersona> personTypes = [
    TipoPersona(nTypePerson: 1, sNamePerson: "Física"),
    TipoPersona(nTypePerson: 2, sNamePerson: "Moral")
  ];

  List<TipoPersona> get getIngresoIVA => personTypes;
}
