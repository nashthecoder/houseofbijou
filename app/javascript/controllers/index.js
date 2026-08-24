import { application } from "controllers/application"

import CalculatorController from "controllers/calculator_controller"
import ToastController from "controllers/toast_controller"
import AutosubmitController from "controllers/autosubmit_controller"
import PanicController from "controllers/panic_controller"
import CountdownController from "controllers/countdown_controller"
import TilegameController from "controllers/tilegame_controller"

application.register("calculator", CalculatorController)
application.register("toast", ToastController)
application.register("autosubmit", AutosubmitController)
application.register("panic", PanicController)
application.register("countdown", CountdownController)
application.register("tilegame", TilegameController)
