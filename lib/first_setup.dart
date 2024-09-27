import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet/components/neu_box.dart';
import 'package:wallet/database/expense_database.dart';
import 'package:wallet/home_page.dart';
import 'package:provider/provider.dart';

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
            effect: const ExpandingDotsEffect(
              activeDotColor: Color.fromRGBO(49, 81, 106, 1),
            ),
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
          // Step 3: Set Categories
          _buildSetCategoryStep(context),
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
          GestureDetector(
            onTap: ()async{
              try{
              await context.read<ExpenseDatabase>().restoreBackup();
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup restored successfully')),
              );
              Navigator.pop(context);
              } catch (e) {
                // Handle any errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const SizedBox(
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
                child: GestureDetector(
                  onTap: () {
                    // Handle category selection
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "PKR",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Pakistani Rupee",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
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

  Widget _buildSetCategoryStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Categories',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select the categories that you want:',
            style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
          ),
          const SizedBox(height: 16),

          // Suggestions header
          const Text(
            "Suggestions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),

          // Categories List
          Expanded(
            child: ListView(
              children: [
                _buildCategoryItem('Sports'),
                _buildCategoryItem('Music'),
                _buildCategoryItem('Technology'),
                _buildCategoryItem('Travel'),
                _buildCategoryItem('Health'),
                // Add more categories as needed
              ],
            ),
          ),

          // Spacer between list and button
          const SizedBox(height: 16),

          // Finish button
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.15,
            child: NeuBox(
              child: MaterialButton(
                onPressed: () async{
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('firstTime', false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text(
                  "Finish",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper method to build individual category items
  Widget _buildCategoryItem(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          // Handle category selection
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            category,
            style: const TextStyle(fontSize: 16),
          ),
        ),
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