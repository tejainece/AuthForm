import 'package:angular/angular.dart';
import 'src/form_component.dart';
@Component(
    selector: 'my-form',
    template: '<register-form></register-form>',
    directives: [FormComponent],
)
class AppComponent {}
