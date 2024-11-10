import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

import 'detail_daily.dart';
import 'detail_hourly.dart';
import 'detail_slot.dart';
import 'detail_standard.dart';
import 'detail_table.dart';

class Booking extends StatefulWidget {
  final int id;

  const Booking({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _BookingState createState() {
    return _BookingState();
  }
}

class _BookingState extends State<Booking> {
  final _bookingCubit = BookingCubit();
  final _textFistNameController = TextEditingController();
  final _textLastNameController = TextEditingController();
  final _textPhoneController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _textMessageController = TextEditingController();

  final _focusFistName = FocusNode();
  final _focusLastName = FocusNode();
  final _focusPhone = FocusNode();
  final _focusEmail = FocusNode();
  final _focusAddress = FocusNode();
  final _focusMessage = FocusNode();

  int _active = 0;
  bool _agree = false;
  String? _errorFirstName;
  String? _errorLastName;
  String? _errorPhone;
  String? _errorEmail;
  String? _errorAddress;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    SVProgressHUD.dismiss();
    _textFistNameController.dispose();
    _textLastNameController.dispose();
    _textPhoneController.dispose();
    _textEmailController.dispose();
    _textAddressController.dispose();
    _textMessageController.dispose();
    _focusFistName.dispose();
    _focusLastName.dispose();
    _focusPhone.dispose();
    _focusEmail.dispose();
    _focusAddress.dispose();
    _focusMessage.dispose();
    super.dispose();
  }

  ///Init data
  void _loadData() async {
    await _bookingCubit.initBooking(widget.id);
  }

  ///On booking
  void _onOrder(FormSuccess form) async {
    final result = await _bookingCubit.order(
      id: widget.id,
      firstName: _textFistNameController.text,
      lastName: _textLastNameController.text,
      phone: _textPhoneController.text,
      email: _textEmailController.text,
      address: _textAddressController.text,
      message: _textMessageController.text,
      form: form,
    );
    if (result.success) {
      if (result.data != null) {
        if (!mounted) return;
        final url = await Navigator.pushNamed(
          context,
          Routes.webView,
          arguments: WebViewModel(
            title: Translate.of(context).translate('payment'),
            url: result.data,
            callbackUrl: ['v1/booking/return', 'v1/booking/cancel'],
          ),
        );
        final cancel = url is String && url.contains('v1/booking/cancel');
        if (url == null || cancel) {
          AppBloc.messageCubit.onShow('payment_not_completed');
        }
      }

      setState(() {
        _active += 1;
      });
    }
  }

  ///On Calc Price
  void _onCalcPrice(FormSuccess form) async {
    final price = await _bookingCubit.calcPrice(
      id: widget.id,
      form: form,
    );
    if (price != null) {
      setState(() {
        form.bookingStyle.price = price;
      });
    }
  }

  ///On next
  void _onNext({
    required FormSuccess form,
    required int step,
  }) async {
    Utils.hiddenKeyboard(context);
    if (step == 0) {
      if (form.bookingStyle.adult == null) {
        AppBloc.messageCubit.onShow('choose_adults_message');
        return;
      }
      if (form.bookingStyle is StandardBookingModel) {
        final style = form.bookingStyle as StandardBookingModel;
        if (style.startDate == null) {
          AppBloc.messageCubit.onShow('choose_date_message');
          return;
        }
        if (style.startTime == null) {
          AppBloc.messageCubit.onShow('choose_time_message');
          return;
        }
      } else if (form.bookingStyle is DailyBookingModel) {
        final style = form.bookingStyle as DailyBookingModel;
        if (style.startDate == null) {
          AppBloc.messageCubit.onShow('choose_date_message');
          return;
        }
      } else if (form.bookingStyle is HourlyBookingModel) {
        final style = form.bookingStyle as HourlyBookingModel;
        if (style.startDate == null) {
          AppBloc.messageCubit.onShow('choose_date_message');
          return;
        }
        if (style.schedule == null) {
          AppBloc.messageCubit.onShow('choose_time_message');
          return;
        }
      } else if (form.bookingStyle is TableBookingModel) {
        final style = form.bookingStyle as TableBookingModel;
        if (style.startDate == null) {
          AppBloc.messageCubit.onShow('choose_date_message');
          return;
        }
        if (style.startTime == null) {
          AppBloc.messageCubit.onShow('choose_time_message');
          return;
        }
        if (style.selected.isEmpty) {
          AppBloc.messageCubit.onShow('choose_table_message');
          return;
        }
      }
      setState(() {
        _active += 1;
      });
    } else if (step == 1) {
      if (_textFistNameController.text.isEmpty) {
        _errorFirstName = Translate.of(context).translate('first_name_message');
      }
      if (_textLastNameController.text.isEmpty) {
        _errorLastName = Translate.of(context).translate('last_name_message');
      }
      if (_textPhoneController.text.isEmpty) {
        _errorPhone = Translate.of(context).translate('phone_message');
      }
      if (_textEmailController.text.isEmpty) {
        _errorEmail = Translate.of(context).translate('email_message');
      }
      if (_textAddressController.text.isEmpty) {
        _errorAddress = Translate.of(context).translate('address_message');
      }
      setState(() {
        if (_errorFirstName == null &&
            _errorLastName == null &&
            _errorPhone == null &&
            _errorEmail == null &&
            _errorAddress == null) {
          if (form.bookingPayment.use) {
            _active += 1;
          } else {
            _onOrder(form);
          }
        }
      });
    } else if (step == 2) {
      _onOrder(form);
    }
  }

  ///Go my booking
  void _onMyBooking() {
    Navigator.pushReplacementNamed(context, Routes.bookingManagement);
  }

  ///On previous
  void _onPrevious() {
    Utils.hiddenKeyboard(context);
    setState(() {
      _active -= 1;
    });
  }

  ///On Open Term
  void _onTerm(FormSuccess form) {
    Navigator.pushNamed(
      context,
      Routes.webView,
      arguments: WebViewModel(
        title: Translate.of(context).translate('term_condition'),
        url: form.bookingPayment.term,
      ),
    );
  }

  ///Widget build detail
  Widget _buildDetail(FormSuccess form) {
    if (form.bookingStyle is StandardBookingModel) {
      return DetailStandard(
        bookingStyle: form.bookingStyle as StandardBookingModel,
        onCalcPrice: () {
          _onCalcPrice(form);
        },
      );
    } else if (form.bookingStyle is DailyBookingModel) {
      return DetailDaily(
        bookingStyle: form.bookingStyle as DailyBookingModel,
        onCalcPrice: () {
          _onCalcPrice(form);
        },
      );
    } else if (form.bookingStyle is HourlyBookingModel) {
      return DetailHourly(
        bookingStyle: form.bookingStyle as HourlyBookingModel,
        onCalcPrice: () {
          _onCalcPrice(form);
        },
      );
    } else if (form.bookingStyle is TableBookingModel) {
      return DetailTable(
        bookingStyle: form.bookingStyle as TableBookingModel,
        onCalcPrice: () {
          _onCalcPrice(form);
        },
      );
    } else if (form.bookingStyle is SlotBookingModel) {
      return DetailSlot(
        bookingStyle: form.bookingStyle as SlotBookingModel,
        onCalcPrice: () {
          _onCalcPrice(form);
        },
      );
    } else {
      return Container();
    }
  }

  ///build contact
  Widget _buildContact() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          AppTextInput(
            hintText: Translate.of(context).translate('input_first_name'),
            errorText: _errorFirstName,
            controller: _textFistNameController,
            focusNode: _focusFistName,
            textInputAction: TextInputAction.next,
            onChanged: (text) {
              setState(() {
                _errorFirstName = UtilValidator.validate(
                  _textFistNameController.text,
                );
              });
            },
            onSubmitted: (text) {
              Utils.fieldFocusChange(
                context,
                _focusFistName,
                _focusLastName,
              );
            },
          ),
          const SizedBox(height: 16),
          AppTextInput(
            hintText: Translate.of(context).translate('input_last_name'),
            errorText: _errorLastName,
            controller: _textLastNameController,
            focusNode: _focusLastName,
            textInputAction: TextInputAction.next,
            onChanged: (text) {
              setState(() {
                _errorLastName = UtilValidator.validate(
                  _textLastNameController.text,
                );
              });
            },
            onSubmitted: (text) {
              Utils.fieldFocusChange(
                context,
                _focusLastName,
                _focusPhone,
              );
            },
          ),
          const SizedBox(height: 16),
          AppTextInput(
            hintText: Translate.of(context).translate('input_phone'),
            errorText: _errorPhone,
            controller: _textPhoneController,
            focusNode: _focusPhone,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            onChanged: (text) {
              setState(() {
                _errorPhone = UtilValidator.validate(
                  _textPhoneController.text,
                  type: ValidateType.phone,
                );
              });
            },
            onSubmitted: (text) {
              Utils.fieldFocusChange(
                context,
                _focusPhone,
                _focusEmail,
              );
            },
          ),
          const SizedBox(height: 16),
          AppTextInput(
            hintText: Translate.of(context).translate('input_email'),
            errorText: _errorEmail,
            controller: _textEmailController,
            focusNode: _focusEmail,
            textInputAction: TextInputAction.next,
            onChanged: (text) {
              setState(() {
                _errorEmail = UtilValidator.validate(
                  _textEmailController.text,
                  type: ValidateType.email,
                );
              });
            },
            onSubmitted: (text) {
              Utils.fieldFocusChange(
                context,
                _focusEmail,
                _focusAddress,
              );
            },
          ),
          const SizedBox(height: 16),
          AppTextInput(
            hintText: Translate.of(context).translate('input_address'),
            errorText: _errorAddress,
            controller: _textAddressController,
            focusNode: _focusAddress,
            textInputAction: TextInputAction.next,
            onChanged: (text) {
              setState(() {
                _errorAddress = UtilValidator.validate(
                  _textAddressController.text,
                );
              });
            },
            onSubmitted: (text) {
              Utils.fieldFocusChange(
                context,
                _focusAddress,
                _focusMessage,
              );
            },
          ),
          const SizedBox(height: 16),
          AppTextInput(
            maxLines: 6,
            hintText: Translate.of(context).translate('input_content'),
            controller: _textMessageController,
            focusNode: _focusMessage,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  ///Build payment
  Widget _buildPayment(FormSuccess form) {
    Widget bankAccountList = Container();
    Widget paymentInfo = Container();

    if (form.bookingPayment.method?.id == 'bank') {
      bankAccountList = Column(
        children: form.bookingPayment.listAccount.map((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.bankName,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Translate.of(context).translate('account_name'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Translate.of(context).translate('iban'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.bankIban,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Translate.of(context).translate('account_number'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.number,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Translate.of(context).translate('swift_code'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.bankSwift,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          );
        }).toList(),
      );
    }
    if (form.bookingPayment.method != null) {
      paymentInfo = Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).focusColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    form.bookingPayment.method?.title ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    form.bookingPayment.method?.description ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    form.bookingPayment.method?.instruction ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          Column(
            children: form.bookingPayment.listMethod.map((item) {
              if (item != form.bookingPayment.listMethod.last) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          activeColor: Theme.of(context).primaryColor,
                          value: item.id,
                          groupValue: form.bookingPayment.method?.id,
                          onChanged: (value) {
                            setState(() {
                              form.bookingPayment.method = item;
                            });
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                item.instruction!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                  ],
                );
              }
              return Row(
                children: [
                  Radio<String>(
                    activeColor: Theme.of(context).primaryColor,
                    value: item.id,
                    groupValue: form.bookingPayment.method?.id,
                    onChanged: (value) {
                      setState(() {
                        form.bookingPayment.method = item;
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          item.instruction!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          paymentInfo,
          const SizedBox(height: 16),
          bankAccountList,
        ],
      ),
    );
  }

  ///Build completed
  Widget _buildCompleted() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Translate.of(context).translate('booking_success_title'),
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            Translate.of(context).translate(
              'booking_success_message',
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }

  ///Widget build content
  Widget _buildContent(FormSuccess form) {
    switch (_active) {
      case 0:
        return _buildDetail(form);
      case 1:
        return _buildContact();
      case 2:
        if (!form.bookingPayment.use) {
          continue success;
        }
        return _buildPayment(form);
      success:
      case 3:
        return _buildCompleted();
      default:
        return Container();
    }
  }

  ///Build action
  Widget _buildAction(FormSuccess form) {
    switch (_active) {
      case 0:
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: AppButton(
            Translate.of(context).translate('next'),
            onPressed: () {
              _onNext(form: form, step: 0);
            },
            mainAxisSize: MainAxisSize.max,
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  Translate.of(context).translate('previous'),
                  onPressed: _onPrevious,
                  mainAxisSize: MainAxisSize.max,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  Translate.of(context).translate('next'),
                  onPressed: () {
                    _onNext(form: form, step: 1);
                  },
                  mainAxisSize: MainAxisSize.max,
                ),
              )
            ],
          ),
        );
      case 2:
        if (!form.bookingPayment.use) {
          continue success;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: _agree,
                    onChanged: (value) {
                      setState(() {
                        _agree = value!;
                      });
                    },
                  ),
                  Text(
                    Translate.of(context).translate('i_agree'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 2),
                  InkWell(
                    onTap: () {
                      _onTerm(form);
                    },
                    child: Text(
                      Translate.of(context).translate('term_condition'),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      Translate.of(context).translate('previous'),
                      onPressed: _onPrevious,
                      mainAxisSize: MainAxisSize.max,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      Translate.of(context).translate('next'),
                      onPressed: () {
                        _onNext(form: form, step: 2);
                      },
                      disabled: !_agree,
                      mainAxisSize: MainAxisSize.max,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      success:
      case 3:
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  Translate.of(context).translate('back'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  mainAxisSize: MainAxisSize.max,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  Translate.of(context).translate('my_booking'),
                  onPressed: _onMyBooking,
                  mainAxisSize: MainAxisSize.max,
                ),
              )
            ],
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('booking'),
        ),
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        bloc: _bookingCubit,
        builder: (context, form) {
          Widget content = Container();
          if (form is FormSuccess) {
            List<StepModel> step = [
              StepModel(
                title: Translate.of(context).translate('details'),
                icon: Icons.calendar_today_outlined,
              ),
              StepModel(
                title: Translate.of(context).translate('contact'),
                icon: Icons.contact_mail_outlined,
              ),
              StepModel(
                title: Translate.of(context).translate('completed'),
                icon: Icons.check,
              )
            ];
            if (form.bookingPayment.use) {
              step = [
                StepModel(
                  title: Translate.of(context).translate('details'),
                  icon: Icons.calendar_today_outlined,
                ),
                StepModel(
                  title: Translate.of(context).translate('contact'),
                  icon: Icons.contact_mail_outlined,
                ),
                StepModel(
                  title: Translate.of(context).translate('payment'),
                  icon: Icons.payment_outlined,
                ),
                StepModel(
                  title: Translate.of(context).translate('completed'),
                  icon: Icons.check,
                )
              ];
            }
            content = Column(
              children: [
                const SizedBox(height: 16),
                AppStepper(
                  active: _active,
                  list: step,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildContent(form),
                  ),
                ),
                _buildAction(form),
              ],
            );
          }
          return SafeArea(
            child: content,
          );
        },
      ),
    );
  }
}
