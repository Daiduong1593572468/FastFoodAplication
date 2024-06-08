import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  static String secret =
      "sk_test_51PPFZ3P9fzMikj77evvizB2hGGneHtPWMfvaYdkYyKtw9yv0S8qX029Pz7NDQJwQnwwVYYpE562dhjIRtBDoNSAs00GZPEqkjM";
  static String publishableKey =
      "pk_test_51PPFZ3P9fzMikj77cAdo22hYeh3FNct4hi0lEw0Ab3Y0iPh7gFaA32GfI5aj8DFgdYXZCpBPp1KosW4AzfeLl9mH008Cenfk45";
  static Future<dynamic> createCheckoutSession(
    List<dynamic> cart,
    total,
  ) async {
    final url = Uri.parse('https://api.stripe.com/v1/checkout/sessions');
    String lineItems = "";
    int index = 0;
    cart.forEach((val) {
      var price = (val['price'] * 100).round().toString();
      lineItems +=
          "&line_items[$index][price_data][product_data][name]=${val['name']}";
      lineItems += "&line_items[$index][price_data][unit_amount]=$price";
      lineItems += "&line_items[$index][price_data][currency]=usd";
      lineItems += "&line_items[$index][quantity]=${val['qty'].toString()}";
      index++;
    });
    final response = await http.post(
      url,
      body:
          'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
      headers: {
        'Authorization': 'Bearer $secret',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    return json.decode(response.body)["id"];
  }

  static Future<dynamic> stripePaymentCheckout(
    cart,
    subtotal,
    context,
    mounted, {
    onSuccess,
    onCancel,
    onError,
  }) async {
    final String seesionId = await createCheckoutSession(cart, subtotal);
    final result = await redirectToCheckout(
      context: context,
      publishableKey: publishableKey,
      sessionId: seesionId,
      successUrl: "https://checkout.stripe.dev/success",
      canceledUrl: "https://checkout.stripe.dev/canceled",
    );
    if (mounted) {
      final text = result.when(
        redirected: () => "Redirected",
        success: () => onSuccess(),
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );
      return text;
    }
  }
}
