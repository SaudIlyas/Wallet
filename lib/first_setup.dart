import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet/components/neu_box.dart';
import 'package:wallet/home_page.dart';

class FirstSetup extends StatelessWidget {
  FirstSetup({super.key}){
    // Initialize the controller when the widget is created
    Get.put(RegistrationController());
  }

  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegistrationController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: GetBuilder<RegistrationController>(
          builder: (_) => SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: const ExpandingDotsEffect(),
          ),
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: controller.setCurrentStep,
        children: [
          // Step 1: Import Backup
          _buildImportBackupStep(context),
          // Step 2: Set Currency
          _buildSetCurrencyStep(context),
          // Step 3: Enter Authentication Code
          _buildEnterAuthCodeStep(context),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  //============================Step 1======================================//

  Widget _buildImportBackupStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Import backup file',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.height * 0.25,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Images/backup_outlined.png"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text.rich(TextSpan(children: [
            TextSpan(
              text: "You can always import your data later if you wish",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ])),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          const SizedBox(
            height: 60,
            child: NeuBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.backup_table_rounded),
                  Text(
                    "Import Backup",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(width: 1),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
            child: const SizedBox(
              height: 60,
              child: NeuBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 1),
                    Text(
                      "Start Fresh",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //============================Step 2======================================//

  Widget _buildSetCurrencyStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Currency',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const NeuBox(
            child: ListTile(
              title: Text("Pakistani Rupee"),
              subtitle: Text("PKR"),
              trailing: Text("Selected"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              focusColor: const Color.fromRGBO(0, 3, 252, 1),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Search (USD, PKR, CAD, etc.)",
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Card(
                  elevation: 2,
                  child: ListTile(
                    tileColor: Colors.grey.shade200,
                    title: const Text(
                      "PKR",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    trailing: const Text(
                      "Pakistani Rupee",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 27),
          GestureDetector(
            onTap: () async {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
            child: const SizedBox(
              height: 60,
              child: NeuBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 1),
                    Text(
                      "Set",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //============================Step 3======================================//

  Widget _buildEnterAuthCodeStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter authentication code',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Enter the 4-digit code that we have sent to your phone number,',
            style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 16),
          const Text(
            "Code",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            style: const TextStyle(
                fontFamily: 'Montserrat', color: Colors.black54),
            decoration: InputDecoration(
              focusColor: Colors.blueAccent,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.15,
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Color.fromRGBO(15, 75, 167, 1)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage()));
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.15,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.grey.shade300),
              ),
              onPressed: () {},
              child: const Text(
                "Resend Code",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationController extends GetxController {
  var currentStep = 0;

  void setCurrentStep(int step) {
    currentStep = step;
    update();
  }

  Future<void> saveRegistrationData() async {
    final prefs = await SharedPreferences.getInstance();
  }
}