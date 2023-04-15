import 'package:flutter_application_4/models/calculate_model.dart';
import 'package:flutter_application_4/models/cliente_model.dart';
import 'package:flutter_application_4/models/periodo.dart';
import 'package:flutter_application_4/models/regimen_model.dart';
import 'package:flutter_application_4/models/subsidio_model.dart';
import 'package:flutter_application_4/models/tarifa_ISR.dart';
import 'package:flutter_application_4/models/tarifa_detalle.dart';
//import 'package:flutter_application_4/screens/tarifa_screen.dart';
import 'package:mysql_client/mysql_client.dart';

class Connection {
  static const String host = "127.0.0.1";
  static const String user = "root";
  static const String dataBase = "mclqroci";
  static const String password = "";
  static const int port = 3306;

  Connection();

  Future<MySQLConnection> getConnection() async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      databaseName: dataBase,
      password: 'root',
    );

    await conn.connect();

    return conn;
  }

  // Insert some data

  Future<bool> insertaCliente(Cliente cliente) async {
    MySQLConnection connection = await getConnection();

    bool bInsertado = false;

    var result = await connection.execute(
        'insert into contribuyente (nTipoPersonaID, sRFC, sRazonSocial, nRegimenID) values (:nTipoPersonaID, :sRFC, :sRazonSocial, :nRegimenID)',
        {
          "nTipoPersonaID": cliente.nTipoPersona,
          "sRFC": cliente.sRFC,
          "sRazonSocial": cliente.sRazonSocial,
          "nRegimenID": cliente.nRegimenID
        });

    if (result.affectedRows.toInt() > 0) bInsertado = true;

    connection.close();

    return bInsertado;
  }

  Future<List<Regimen>> obtenerTiposRegimen(int nTipoPersonaID) async {
    MySQLConnection connection = await getConnection();

    List<Regimen> regimenes = [];

    var result = await connection.execute('''
      SELECT 
        * 
      FROM 
        regimen r
        INNER JOIN regimen_tipo_persona rp ON rp.nRegimenID = r.nRegimenID
      WHERE 
        rp.nTipoPersonaID = :nTipoPersonaID
      ORDER BY 
        rp.nTipoPersonaID;''', {"nTipoPersonaID": nTipoPersonaID});

    for (var row in result.rows) {
      regimenes.add(Regimen(
          nRegimenID: int.parse(row.colByName('nRegimenID')!),
          sNombreRegimen: row.colByName('sNombreRegimen')!));
    }
    connection.close();

    return regimenes;
  }

  Future<List<Periodo>> obtenerPeriodos() async {
    List<Periodo> periodos = [];
    MySQLConnection connection = await getConnection();
    var result = await connection.execute('SELECT * FROM periodo');

    for (var row in result.rows) {
      periodos.add(Periodo(
        nPeriodoID: int.parse(row.colByName("nPeriodoID")!),
        nAgno: row.colByName("nYear")!,
        nMes: row.colByName("nMonth")!,
      ));
    }
    connection.close();

    return periodos;
  }

  Future<List<Cliente>> obtenerClintes() async {
    MySQLConnection connection = await getConnection();

    List<Cliente> clientes = [];

    var result = await connection.execute('''SELECT 
              c.*, 
              r.sNombreRegimen 
            FROM 
              contribuyente c 
              LEFT JOIN regimen r ON r.nRegimenID = c.nRegimenID''');

    for (var row in result.rows) {
      clientes.add(Cliente(
          nClientID: int.parse(row.colByName("nContribuyenteID")!),
          sRazonSocial: row.colByName("sRazonSocial")!,
          nRegimenID: int.parse(row.colByName("nRegimenID")!),
          sNombreRegimen: row.colByName("sNombreRegimen")!,
          sRFC: row.colByName("sRFC")!,
          simulado: false,
          sTipoPersona: int.parse(row.colByName("nTipoPersonaID")!) == 1
              ? 'Persona Física'
              : 'Persona Moral',
          nTipoPersona: int.parse(row.colByName("nTipoPersonaID")!)));
    }
    connection.close();

    return clientes;
  }

  Future<List<TarifaISR>> obtenerTarifas() async {
    MySQLConnection connection = await getConnection();

    List<TarifaISR> tarifas = [];

    var result = await connection.execute('''
      SELECT 
        * 
      FROM 
        tarifa_isr
      WHERE 
	      nTarifaISR <> 4        
      ORDER BY 
        sNombreTarifa''');

    for (var row in result.rows) {
      tarifas.add(
        TarifaISR(
            nTarifaISR: int.parse(row.colByName("nTarifaISR")!),
            sNombreTarifa: row.colByName("sNombreTarifa")!),
      );
    }
    connection.close();

    return tarifas;
  }

  Future<List<SubcidioEmpleo>> obtenerSubsidio() async {
    MySQLConnection connection = await getConnection();

    List<SubcidioEmpleo> subsidio = [];

    var result = await connection.execute('''
      SELECT 
        * 
      FROM 
        subsidio_detalle''');

    for (var row in result.rows) {
      subsidio.add(
        SubcidioEmpleo(
          nSubsidioID: int.parse(row.colByName("nSusidioID")!),
          nSubsidioDetalleID: int.parse(row.colByName("nSubsidioDetalleID")!),
          dLimiteInferior: double.parse(row.colByName("dLimiteInferior")!),
          dLimiteSuperior: double.parse(row.colByName("dLimiteSuperior")!),
          dSubsidio: double.parse(row.colByName("dSubsidio")!),
        ),
      );
    }
    connection.close();

    return subsidio;
  }

  Future<List<TarifaDetalle>> obtenerTarifaDetallle(int nTarifaISRID) async {
    MySQLConnection connection = await getConnection();

    List<TarifaDetalle> tarifas = [];

    var result = await connection.execute('''
    SELECT 
      * 
    FROM 
      tarifa_isr t
      INNER JOIN tarifa_isr_detalle td ON td.nTarifaID = t.nTarifaISR
      LEFT JOIN periodo p ON p.nPeriodoID = td.nPeriodo
    WHERE 
	    t.nTarifaISR = :nTarifaISR
    ORDER  BY 
      p.nPeriodoID, dLimiteInferior''', {"nTarifaISR": nTarifaISRID});

    for (var row in result.rows) {
      tarifas.add(
        TarifaDetalle(
          nTarifaDetalleID: int.parse(row.colByName("nTarifaDetalleID")!),
          dLimiteInferior: double.parse(row.colByName("dLimiteInferior")!),
          dLimiteSuperior: double.parse(row.colByName("dLimiteSuperior")!),
          dCuotaFija: double.parse(row.colByName("dCuotaFija")!),
          dSobreexedente: row.colByName("dSobreexedente") != null
              ? double.parse(row.colByName("dSobreexedente")!)
              : 0,
          periodo: Periodo(
            nPeriodoID: row.colByName("nPeriodoID") != null
                ? int.parse(row.colByName("nPeriodoID")!)
                : 0,
            nAgno:
                row.colByName("nYear") != null ? row.colByName("nYear")! : '',
            nMes:
                row.colByName("nMonth") != null ? row.colByName("nMonth")! : '',
          ),
        ),
      );
    }
    connection.close();

    return tarifas;
  }

  Future<IResultSet> calcularImpuesto(
      Calculo calculo, int nRegimenID, int nTipoPersonaID) async {
    MySQLConnection conn = await getConnection();

    String sql = '';

    List<dynamic> params = [
      calculo.getIngresoIVA,
      calculo.getingresoSinIVA,
      calculo.getDeduccionIVA,
      calculo.getDeduccionSinIVA
    ];

    switch (nRegimenID) {
      case 2:
        if (nTipoPersonaID == 1) {
          sql = "CALL calculaPersonaFisicaRESICO(?, ?, ?, ?)";
        } else {
          sql = "CALL calculaPersonaMoralRESICO(?, ?, ?, ?)";
        }

        break;

      case 3:
        sql = "CALL calculaPersonaFisicaActividadEmpresarial(?, ?, ?, ?, ?, ?)";
        params.add(calculo.getRetencionImpuesto ? 1 : 0);
        params.add(calculo.getPeriodo);
        break;

      case 4:
        sql = "CALL calculaArrendamientoInmuebles(?, ?, ?, ?, ?)";
        params.add(calculo.getDeduccionCiega);

        break;

      case 6:
        sql = "CALL calculaPersonaFisicaAsalariadoQuincenal(?, ?, ?, ?)";
        break;
      case 9:
        sql = "CALL calculaPersonaMoralRegimenGeneralCU(?, ?, ?, ?, ? ,?)";
        params.add(calculo.getCoeficienteUtilidad);
        params.add(calculo.getRetencionImpuesto ? 1 : 0);
        break;

      case 12:
        sql = "CALL calculaPersonaFisicaAsimilado(?, ?, ?, ?)";
        break;

      default:
    }

    //if (sql.isEmpty) return ;

    final stmt = await conn.prepare(sql);
    final result = await stmt.execute(params);

    await stmt.deallocate();

    return result;
  }
}
