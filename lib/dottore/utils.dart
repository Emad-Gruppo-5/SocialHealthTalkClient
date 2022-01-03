
import 'package:sht/dottore/patient_list_item.dart';

class Utils {

  static List<PatientListItem> getPatientList(){
    return [
      PatientListItem(
        name: 'Lorenzo',
        surname: 'Petrazzuolo',
        lastAccess: 'Online',
        state: true,
        codFiscale: 'TVCCNC36S53C308Z',
        numCell: '+39 388 55 812',
        email: "lorenzopetrazzuolo@gmail.com",
        eta: 55,
        sesso: 'M',
        titoloStudio: 'Diploma agrario',
        note: 'Particolarmente istruito'
      ),
      PatientListItem(
        name: 'Lorenzo',
        surname: 'Musto',
        lastAccess: 'Offline da 5m',
        state: false,
        codFiscale: 'TVCCNC36S53C308Z',
        numCell: '+39 388 55 812',
        email: "lorenzopetrazzuolo@gmail.com",
        eta: 55,
        sesso: 'M',
        titoloStudio: 'Diploma agrario',
        note: 'Particolarmente istruito'
      ),
      PatientListItem(
        name: 'Lorenzo',
        surname: 'Petrazzuolo',
        lastAccess: 'Offline da 20m',
        state: false,
        codFiscale: 'TVCCNC36S53C308Z',
        numCell: '+39 388 55 812',
        email: "lorenzopetrazzuolo@gmail.com",
        eta: 55,
        sesso: 'M',
        titoloStudio: 'Diploma agrario',
        note: 'Particolarmente istruito'
      )
    ]; 
  }

}