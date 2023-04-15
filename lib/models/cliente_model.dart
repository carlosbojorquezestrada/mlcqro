class Cliente {
  Cliente(
      {required this.nClientID,
      required this.sRazonSocial,
      required this.nRegimenID,
      required this.sNombreRegimen,
      required this.sRFC,
      required this.nTipoPersona,
      required this.sTipoPersona,
      required this.simulado});

  int nClientID;
  String sRazonSocial;
  String sRFC;
  String sNombreRegimen;
  int nRegimenID;
  int nTipoPersona;
  bool simulado;
  String sTipoPersona;
}
