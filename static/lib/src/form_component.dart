import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'form.dart';

@Component(
    selector: 'my-form',
    templateUrl: 'form_component.html',
    directives: [coreDirectives, formDirectives],
)
class FormComponent {

    AuthForm model = new AuthForm('', '');

    String get username => model.username;
    String get password => model.password;

    bool submitted = false;
    void onSubmit() => submitted = true;
    /// Returns a map of CSS class names representing the state of [control].
    Map<String, bool> setCssValidityClass(NgControl control) {
        final validityClass = control.valid == true ? 'is-valid' : 'is-invalid';
        return {validityClass: true};
    }
    void clear() {
        model.username = '';
        model.password = '';
    }
}