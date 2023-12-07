import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipeapp/details_screen.dart';
import 'package:foodrecipeapp/my_profile_screen.dart';
import 'package:foodrecipeapp/search_screen.dart';
import 'package:foodrecipeapp/user_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final chefNames = [
    "Aleeza",
    "Ali Hussan",
    "Noor",
    "Riaz Cheema",
    "Habiba Fatima",
    "Jahanzaib",
    "Danish Ali",
    "Awais",
    "Nimra",
    "Minahil",
    "Uswa Khan",
    "Fatima",
    "Kanza",
    "Madiha",
    "Amna",
    "Mariyum",
  ];
  final images = [
    "assets/images/lahori_chicken.jpg",
    "assets/images/saag.jpg",
    "assets/images/tomato_karai.jpg",
    "assets/images/khageena.jpg",
    "assets/images/pike_skeins.jpg",
    "assets/images/biryani.jpg",
    "assets/images/chany.jpeg",
    "assets/images/mix_sabzi.jpg",
    "assets/images/potato karahi.jpg",
    "assets/images/sevian.jpg",
    "assets/images/bhindi.jpg",
    "assets/images/cheese_dish.jpg",
    "assets/images/karela_sabzi.jpg",
    "assets/images/daal_rice.jpg",
    "assets/images/nutloaf_with_shiltakeGravy.jpg",
    "assets/images/chickpease_corn_capsicum_puff.jpg",
  ];
  final foodName = [
    "Lahori Chicken",
    "Sarson ka Saag",
    "Tomamto Karahi",
    "Khageena",
    "Onion Bartha",
    "Biryani",
    "Chaney",
    "Mix Sabzi",
    "Potato Karahi",
    "Sevian",
    "Bhindi",
    "Cheese Dish",
    "Karela Sabzi",
    "Daal Rice",
    "Nutloaf",
    "Capsicum Puff",
  ];
  final foodCalories = [
    "140K Cal",
    "120K Cal",
    "110K Cal",
    "40K Cal",
    "70K Cal",
    "100K Cal",
    "60K Cal",
    "122K Cal",
    "99K Cal",
    "101K Cal",
    "10K Cal",
    "20K Cal",
    "30K Cal",
    "40K Cal",
    "50K Cal",
    "60K Cal"
  ];
  final foodIngrediants = [
    "12",
    "11",
    "16",
    "6",
    "9",
    "7",
    "6",
    "5",
    "3",
    "2",
    "8",
    "7",
    "6",
    "5",
    "3",
    "2",
  ];
  final foodTime = [
    "3 hours",
    "2 hours",
    "1.5 hours",
    "4 hours",
    "1 hours",
    "2.5 hours",
    "3 hours",
    "2.5 hours",
    "4 hours",
    "3.5 hours",
    "4 hours",
    "1 hours",
    "2.5 hours",
    "3 hours",
    "2.5 hours",
    "4 hours",
    "3.5 hours",
  ];
  final recipeDescription = [
    "Lahori Chicken, a culinary gem from the heart of Lahore, Pakistan, is a dish that proudly showcases the rich heritage and distinctive flavors of the region. This beloved recipe is a testament to the culinary expertise passed down through generations, offering a tantalizing fusion of traditional spices and local ingredients. Lahori Chicken is not just a dish; it's a celebration of the vibrant and diverse food culture that defines Lahore, known for its bold and robust flavors that leave an indelible mark on the palate.",
    "Sarson ka Saag, a culinary masterpiece hailing from the fertile lands of Punjab, is a celebration of the region's agricultural abundance and traditional flavors. This iconic dish pays homage to the humble mustard plant, locally known as sarson, whose vibrant green leaves are transformed into a delectable saag. Known for its nutritional richness, Sarson ka Saag is more than a dish; it is a cultural symbol, deeply rooted in the agrarian heritage of Punjab. This wholesome recipe captures the essence of simplicity, sustainability, and the authentic flavors of the land.",
    "Tomato Karahi, a culinary gem from South Asian kitchens, is a delightful dish that places ripe tomatoes at the heart of its flavor profile. Celebrated for its vibrant colors and rich taste, this recipe is a harmonious blend of tangy tomatoes, aromatic spices, and tender meat. Tomato Karahi not only tantalizes the taste buds but also captures the essence of the region's culinary artistry, making it a favorite among those who appreciate the bold and savory flavors of South Asian cuisine.",
    "Khageena, a culinary gem with roots in South Asian cuisine, is a dish that embodies the rustic charm and simple elegance of home-cooked meals. This versatile recipe is known for its comforting flavors and the ability to transform basic ingredients into a wholesome and satisfying dish. Khageena is a celebration of simplicity, allowing the natural taste of eggs and spices to shine, making it a popular choice for those seeking a quick and delicious meal with a touch of home-cooked warmth.",
    "Onion Bartha, a culinary delight rooted in Indian cuisine, is a dish that pays homage to the humble onion, transforming it into a savory and aromatic delicacy. This recipe showcases the art of slow-cooking onions to perfection, allowing them to caramelize and develop rich, deep flavors. Onion Bartha is a testament to the culinary finesse that can be achieved with a few simple ingredients, making it a cherished dish that captivates the senses with its sweet and smoky essence.",
    "Biryani, a crown jewel in the world of culinary delights, is a revered dish that traces its origins to the rich tapestry of South Asian cuisine. Renowned for its aromatic blend of fragrant rice, tender meat, and an intricate mix of spices, Biryani is a celebration of flavors that transcends borders. This regal dish reflects the cultural diversity and culinary mastery of the region, making it a symbol of festive feasts, special occasions, and the warmth of shared meals with loved ones.",
    "Chana Masala, a cherished classic in Indian cuisine, is a flavorful and hearty dish that highlights the versatility of chickpeas. Renowned for its bold blend of spices and rich tomato-based gravy, Chana Masala is a favorite among vegetarians and meat enthusiasts alike. This recipe embodies the heartiness of chickpeas, creating a wholesome and satisfying meal that delights the palate with each bite. With its aromatic spices and savory profile, Chana Masala stands as a testament to the culinary artistry of Indian kitchens.",
    "Mix Sabzi, a delightful medley of fresh vegetables, is a versatile and vibrant dish that showcases the bountiful colors and flavors of a diverse array of veggies. This recipe is a celebration of nature's bounty, combining the earthy goodness of potatoes, carrots, peas, and other seasonal vegetables. Mix Sabzi is a go-to choice for those seeking a wholesome and nutritious side dish that complements a variety of meals. Its simplicity lies in the harmonious blend of different textures and tastes, making it a beloved addition to any dining table.",
    "Potato Karahi, a delightful twist to the traditional Karahi recipes, celebrates the humble potato as the star ingredient. This dish is a flavorful homage to the versatility of potatoes, transforming them into a savory and aromatic delicacy. Potato Karahi showcases the rich and robust flavors of South Asian cuisine while adding a unique and comforting touch with every bite. With its simplicity and heartiness, Potato Karahi stands as a cherished favorite, inviting food enthusiasts to savor the delicious marriage of spices and potatoes.",
    "Sevian, a cherished dessert in South Asian cuisine, is a delightful creation that transforms simple vermicelli into a sweet and aromatic treat. This recipe is a celebration of texture and flavor, combining thin strands of vermicelli with ghee, sugar, and a medley of nuts. Sevian is not just a dessert; it is a symbol of festive occasions, family gatherings, and the joyous spirit of sharing sweets with loved ones. With its simplicity and heartwarming sweetness, Sevian holds a special place in the realm of South Asian desserts.",
    "Bhindi, also known as Okra, is a vegetable that takes center stage in South Asian cuisine, celebrated for its distinctive taste and versatility. This recipe showcases the vibrant green pods of okra, which are prized for their unique texture and ability to absorb flavors. Bhindi is a flavorful and nutritious addition to any meal, offering a delightful combination of earthy richness and subtle sweetness. Whether stir-fried, stuffed, or added to curries, Bhindi stands as a beloved vegetable in the culinary landscape.",
    "A Cheese Dish, a true indulgence for cheese enthusiasts, embodies the rich and diverse world of this beloved dairy product. Whether it's a creamy macaroni and cheese, a decadent cheese fondue, or a gourmet baked dish, the possibilities with cheese are endless. This recipe category is a celebration of the luscious textures, bold flavors, and varied forms of cheese, offering a delightful journey for those who appreciate the delectable nuances of this dairy delight. From mild and melty to sharp and tangy, a Cheese Dish is a culinary canvas ready to be explored and enjoyed.",
    "Karela Sabzi, featuring the distinctive bitterness of the bitter gourd, is a unique and nutritious dish that holds a special place in South Asian cuisine. Despite its bold flavor profile, this recipe transforms bitter gourd into a flavorful and wholesome culinary experience. Karela Sabzi is not just a dish; it's a testament to the art of balancing flavors, showcasing how careful preparation can turn a seemingly challenging ingredient into a delicious and healthful addition to the dining table.",
    "Daal Rice, a timeless and comforting classic, is a staple dish that holds a special place in South Asian households. This recipe embodies the essence of simplicity and wholesomeness, combining lentils and rice to create a hearty and nutritious meal. Daal, or lentils, provide a rich source of protein, while the rice offers a satisfying base. Daal Rice is not just a dish; it's a soul-warming experience that symbolizes the heart of home-cooked comfort food.",
    "Nutloaf with Shiitake Gravy, a sophisticated and hearty plant-based dish, redefines the art of vegetarian cuisine. This recipe is a celebration of wholesome ingredients, combining nuts, grains, and aromatic shiitake mushrooms to create a flavorful and satisfying nutloaf. Paired with a savory shiitake gravy, this dish is a testament to the creativity and culinary innovation that elevates vegetarian cooking to a gourmet experience, offering a delightful alternative for those seeking a hearty and meatless feast.",
    "Chickpeas Corn Capsicum Puff, a delightful fusion snack, marries the heartiness of chickpeas with the sweetness of corn and the vibrant crunch of capsicum, all encased in flaky puff pastry. This recipe is a celebration of flavors and textures, offering a savory and satisfying experience for those who crave a crispy and wholesome snack. The combination of chickpeas, corn, and capsicum creates a symphony of tastes that transforms a simple puff into a gourmet delight, making it a perfect choice for parties or casual gatherings."
  ];
  final cookingMethod = [
    "To create the flavorful masterpiece that is Lahori Chicken, begin by marinating succulent pieces of chicken in a blend of aromatic spices such as cumin, coriander, turmeric, and garam masala. Allow the chicken to soak in the rich marinade, infusing it with the essence of Lahori spices. In a hot pan, sizzle finely chopped onions until golden brown, then add ginger-garlic paste to elevate the dish's depth. The marinated chicken is then added to the pan, where it is expertly cooked until tender and juicy.\nAs the kitchen fills with the irresistible aroma, tomatoes, green chilies, and a touch of yogurt join the ensemble, enhancing the dish's complexity and creaminess. Lahori Chicken is known for its bold and spicy profile, which is achieved through a careful balance of chili powder and other fiery spices. Garnished with fresh coriander leaves and a squeeze of lime, this iconic dish is a true representation of Lahori culinary prowess. When served with naan or rice, Lahori Chicken becomes a flavorful journey that transports diners to the bustling streets of Lahore, where every bite tells a story of tradition, passion, and delicious innovation.",
    "To craft the sumptuous Sarson ka Saag, start by harvesting fresh mustard leaves and spinach. After thorough cleaning, the greens are finely chopped and simmered in a pot along with water. The magic begins as the leaves tenderize, releasing their natural flavors. Adding a hint of maize flour, or makki ka atta, imparts a unique texture and nuttiness to the saag. The cooking process involves slow simmering, allowing the flavors to meld and intensify.\nIn a separate pan, finely chopped onions are sautéed until golden brown, and ginger-garlic paste is added to infuse depth. This aromatic base is then combined with the simmered greens, creating a harmonious blend of textures and tastes. A symphony of spices, including cumin, coriander, and garam masala, elevates the saag to new heights. The final touch involves a dollop of ghee, enhancing the dish with richness and a velvety finish. Served with makki ki roti and a dollop of fresh butter, Sarson ka Saag stands as a testament to the rustic flavors and agricultural traditions of Punjab, providing a wholesome and satisfying culinary experience.",
    "To prepare the enticing Tomato Karahi, start by heating a karahi or deep pan on medium heat. Add oil and sauté finely chopped onions until they turn golden brown. Introduce ginger-garlic paste, allowing it to infuse the dish with its aromatic essence. Add diced tomatoes, green chilies, and a medley of spices, including cumin, coriander, and garam masala. Let the tomatoes soften and release their juices.\nNow, add your choice of meat, whether it's succulent chicken or flavorful lamb, and let it cook until tender. Yogurt is then incorporated to lend a creamy texture to the dish. Adjust the seasoning to taste, and finish the Tomato Karahi with a sprinkle of fresh coriander leaves and a dash of lemon juice. Served hot, this culinary masterpiece is a testament to the vibrant flavors and culinary traditions that define South Asian cuisine, offering a truly memorable dining experience.",
    "To prepare the delightful Khageena, start by whisking together eggs in a bowl, incorporating a medley of spices such as turmeric, cumin, and red chili powder. In a hot pan, sauté finely chopped onions until they turn golden brown, infusing the dish with a sweet and savory base. Add chopped tomatoes and green chilies to the pan, allowing them to soften and meld with the aromatic spices.\nOnce the base is ready, pour in the beaten eggs, gently stirring to create soft and fluffy curds. The key is to cook the eggs slowly, allowing them to absorb the rich flavors of the spices. Fresh cilantro or coriander leaves add a burst of freshness and color, completing the dish. Khageena is often served hot with naan or chapati, making it a delightful choice for breakfast or a quick and wholesome meal. With its minimal ingredients and maximum flavor, Khageena is a beloved recipe that brings joy to the table with its homely and comforting appeal.",
    "To craft the delectable Onion Bartha, start by charring whole onions over an open flame until the skins turn black, imparting a smoky aroma. Once charred, peel and finely mash the onions. In a pan, heat a generous amount of ghee and add cumin seeds, allowing them to sizzle and release their fragrance. Stir in finely chopped garlic and ginger until they become golden brown.\nNext, add finely pureed tomatoes to the pan, allowing them to cook down and create a luscious base. Introduce a blend of aromatic spices, including turmeric, coriander, and red chili powder, to infuse the dish with a symphony of flavors. Finally, fold in the mashed onions, letting them absorb the rich spices and ghee. Cook the mixture until it reaches a velvety consistency, and finish with a garnish of fresh coriander leaves. Onion Bartha, when served hot with naan or rice, becomes a soul-warming experience that elevates the humble onion to a culinary masterpiece.",
    "To embark on the journey of crafting the perfect Biryani, start by marinating succulent pieces of meat in a blend of yogurt and an array of spices, including cumin, coriander, and garam masala. Parboil basmati rice until it's almost cooked, and layer it alternately with the marinated meat in a deep pot. Sprinkle fried onions, mint, and cilantro between the layers to enhance the dish's depth.\nInfuse saffron or food color in warm milk and drizzle it over the layered Biryani for a vibrant and aromatic touch. Seal the pot with a tight-fitting lid and let the Biryani undergo the slow cooking process, allowing the rice to absorb the flavorful essence of the spices and meat. The result is a fragrant and visually stunning Biryani that captivates the senses and invites everyone to savor the symphony of tastes. When served with raita or a side of spicy curry, Biryani stands as a culinary masterpiece that embodies the soul of South Asian cuisine.",
    "To embark on the delightful journey of making Chana Masala, begin by sautéing finely chopped onions in a pan until golden brown. Add ginger-garlic paste to infuse the dish with a fragrant aroma, then introduce a medley of spices, including cumin, coriander, turmeric, and garam masala. Stir in finely diced tomatoes, allowing them to cook down and form a rich base.\nThe star of the show, chickpeas, are added to the aromatic mixture, absorbing the flavorful essence of the spices. Simmer the dish until the chickpeas are tender and the gravy reaches a desirable consistency. A final garnish of fresh cilantro and a squeeze of lemon juice elevates Chana Masala to perfection. Served hot with rice or naan, this delightful dish is a celebration of the robust and intricate flavors that define Indian cuisine, providing a wholesome and satisfying dining experience.",
    "To prepare the scrumptious Mix Sabzi, start by heating oil in a pan and sautéing a blend of finely chopped onions until they turn golden brown. Add a touch of cumin seeds and let them sizzle to release their aromatic flavors. Toss in an assortment of colorful vegetables such as potatoes, carrots, and peas, allowing them to cook until tender yet retaining their crispiness.\nIntroduce a combination of ground spices, including turmeric, cumin, coriander, and a pinch of red chili powder, to infuse the vegetables with a medley of flavors. Season with salt to taste and stir the mixture gently, ensuring every vegetable is coated in the aromatic spice blend. Garnish the Mix Sabzi with fresh cilantro or parsley for a burst of freshness. Served hot as a side dish or as a flavorful stuffing for wraps and sandwiches, Mix Sabzi is a versatile and delicious way to savor the goodness of mixed vegetables.",
    "To craft the enticing Potato Karahi, start by heating a karahi or deep pan on medium heat. Add oil and sauté finely chopped onions until they turn golden brown. Introduce ginger-garlic paste to infuse the dish with its aromatic essence. Add diced potatoes and a medley of spices, including cumin, coriander, turmeric, and garam masala, allowing the potatoes to absorb the rich flavors.\nToss in finely chopped tomatoes, green chilies, and a touch of yogurt, creating a delightful blend of textures and tastes. Let the potatoes cook until they are tender and infused with the aromatic spices. Adjust the seasoning to taste and finish with a sprinkle of fresh coriander leaves for a burst of freshness. Potato Karahi, when served hot with naan or rice, becomes a comforting and flavorful dish that highlights the culinary magic of South Asian kitchens.",
    "To prepare the luscious Sevian, begin by toasting vermicelli in a pan with a generous amount of ghee until it turns golden brown and emanates a nutty aroma. Add a mixture of water and milk to the pan, allowing the vermicelli to absorb the liquid and soften to a delectable consistency. Stir in sugar, cardamom powder, and a handful of chopped nuts, such as almonds and pistachios, enhancing the dessert with a rich and nutty profile.\nSimmer the mixture until the vermicelli is fully cooked and the flavors meld together, creating a creamy and sweet delight. Garnish with additional nuts for a visually appealing touch. Served warm, Sevian is a soul-satisfying dessert that encapsulates the essence of traditional South Asian sweets, offering a delightful conclusion to any meal or a sweet treat for joyous celebrations.",
    "To prepare the delectable Bhindi, start by washing and thoroughly drying the okra to remove any excess moisture. Trim the ends and slice the pods into bite-sized pieces. In a hot pan, add oil and toss in cumin seeds, letting them sizzle to release their aromatic flavors. Introduce finely chopped onions and sauté until golden brown. Add the sliced okra to the pan, ensuring each piece is coated with the fragrant mixture.\nSeason the Bhindi with a blend of spices, including turmeric, coriander, cumin, and a pinch of red chili powder, enhancing the vegetable with a medley of flavors. Cook the okra until it is tender yet retains a slight crispiness. Finish with a squeeze of lemon juice and a garnish of fresh cilantro for added freshness. Bhindi, when served hot as a side dish or part of a larger meal, showcases the delightful marriage of flavors and textures that make okra a culinary favorite.",
    "To craft a mouthwatering Cheese Dish, the process often begins with selecting a variety of cheeses to create a harmonious blend of flavors. From cheddar and mozzarella to gouda and blue cheese, the choices are vast and can be tailored to suit individual preferences. Whether melted into a velvety sauce, layered between pasta, or baked to golden perfection, the cooking method for a Cheese Dish is as diverse as the types of cheese used.\nFor a classic macaroni and cheese, start by creating a cheese sauce with butter, flour, and milk, then fold in a combination of shredded cheeses until smooth and creamy. Layer the sauce with cooked pasta, bake until bubbly, and enjoy a comforting dish that showcases the gooey allure of melted cheese. The cooking method may vary based on the specific type of Cheese Dish, but the common thread is the celebration of cheese in all its flavorful glory.",
    "To prepare the flavorful Karela Sabzi, begin by washing and thinly slicing the bitter gourd. To reduce bitterness, sprinkle salt on the slices and let them sit for a while before rinsing. In a pan, heat oil and add cumin seeds, letting them sizzle. Incorporate finely chopped onions and sauté until golden brown. Add the sliced bitter gourd, and stir in a medley of spices, including turmeric, coriander, cumin, and a pinch of red chili powder.\nCook the bitter gourd until it is tender yet retains a hint of crunchiness. To balance the bitterness, add a touch of sweetness, either through a dash of jaggery or a spoonful of tomato paste. Finish with a squeeze of lemon juice to brighten the flavors. Karela Sabzi, when served hot as a side dish or part of a larger meal, is a testament to the culinary magic of transforming bold and challenging flavors into a delicious and nutritious creation.",
    "To prepare the nourishing Daal Rice, start by rinsing and soaking the lentils in water. In a pot, combine the soaked lentils with water, add a pinch of turmeric, and bring to a boil. Simmer until the lentils are tender and have absorbed the flavors. In a separate pot, cook rice until fluffy and set aside.\nIn a pan, heat ghee or oil and add cumin seeds, allowing them to sizzle. Add finely chopped onions and sauté until golden brown. Introduce ginger-garlic paste and a medley of spices, such as cumin, coriander, and garam masala, to infuse the dish with aromatic flavors. Combine the cooked lentils with the spice mixture, adjusting the consistency with water if needed\nServe the flavorful Daal over a bed of steamed rice. Garnish with fresh cilantro and a squeeze of lemon juice for a burst of freshness. Daal Rice, when enjoyed hot, exemplifies the heartiness and simplicity that characterize home-cooked meals, providing a wholesome and satisfying dining experience.",
    "To craft the delectable Nutloaf with Shiitake Gravy, start by combining a mix of nuts, such as walnuts, almonds, and cashews, with cooked quinoa, breadcrumbs, and an assortment of finely chopped vegetables like carrots and onions. Season the mixture with herbs and spices, molding it into a loaf shape. Bake until the nutloaf is golden brown and holds its shape.\nFor the Shiitake Gravy, sauté sliced shiitake mushrooms in a pan with olive oil until they release their rich aroma. Add finely minced garlic and onions, cooking until softened. Incorporate vegetable broth, soy sauce, and a touch of flour to create a velvety gravy. Simmer until the flavors meld together, adjusting the seasoning as needed.\nSlice the nutloaf and serve it drizzled with the savory shiitake gravy. Garnish with fresh herbs for a burst of color and freshness. Nutloaf with Shiitake Gravy stands as a testament to the diverse and satisfying possibilities of vegetarian cuisine, offering a gourmet experience for those who appreciate the richness of plant-based flavors.",
    "To create the mouthwatering Chickpeas Corn Capsicum Puff, start by sautéing chickpeas, sweet corn, and finely diced capsicum in a pan with a touch of olive oil. Season the mixture with a blend of spices, such as cumin, paprika, and a pinch of chili powder, to infuse the filling with robust flavors. Allow the mixture to cool.\nRoll out sheets of puff pastry and cut them into squares. Place a generous spoonful of the chickpea-corn-capsicum filling in the center of each square. Fold the pastry over the filling, creating a triangle, and seal the edges. Bake until the puff pastry turns golden brown and flaky.\nServe the Chickpeas Corn Capsicum Puffs hot, allowing the enticing aroma to fill the air. This delightful snack, with its harmonious blend of chickpeas, corn, and capsicum, is a crowd-pleaser that elevates the classic puff pastry to new heights of flavor and satisfaction."
  ];
  String search = '';
  TextEditingController searchController = TextEditingController();

  UserModel? userData;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchUserData();
    });
  }

  void fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users_accounts')
        .doc(user?.uid)
        .get();

    userData = UserModel(
      name: userDataSnapshot['Name'],
      email: userDataSnapshot['Email'],
      imageUrl: userDataSnapshot['Image'],
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF0E234F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text('Hello ${userData?.name ?? 'User'} What would you like to cook today?', style: TextStyle(fontSize: 24, color: Colors.orange),)
                      ),
                      SizedBox(width: 40,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen(),));
                        },
                        child: Hero(
                          tag: 'profile',
                          child: ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 4, // Border width
                                ),
                                color: Color(0xFF0E234F),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: userData?.imageUrl != null
                                    ? Image.network(userData!.imageUrl,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/error_image.png',fit: BoxFit.fitWidth,);
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF0E234F),
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ).image
                                    : Image.asset('assets/images/pic8.png').image,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF0E234F)),
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Color(0xFF0E234F)),
                        SizedBox(width: 8),
                        Text(
                          'Search Recipe',
                          style: TextStyle(color: Color(0xFF0E234F)),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.orange
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/chef.png'),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 120,top: 40),
                      width: double.infinity,
                      height: 80,
                      child: Text('From kitchen to heart, a culinary journey',style: TextStyle(fontSize: 18,color: Color(0xFF0E234F),fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
                SizedBox(height: 30,),
                Container(
                  height: size.height * 0.25,
                  child: ListView.separated(
                    shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index) {
                        if (index < 4) {
                          return GestureDetector(
                            onTap: () {
                              _navigateToDetailScreen(index);
                            },
                            child: AspectRatio(
                              aspectRatio: 0.9 / 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Hero(
                                      child: Container(
                                        child: ClipRRect(
                                          child: Image.asset(
                                            images[index],
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      tag: images[index],
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "${foodName[index]} Recipe",
                                      style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                      separatorBuilder: (context, _) => SizedBox(width: 16,),
                      itemCount: 4),
                ),
                SizedBox(height: 20,),
                Text('Special Recipes',style: TextStyle(fontSize: 20,color: Colors.orange),),
                SizedBox(height: 10,),
                Container(
                  height: size.height * 0.335,
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index) {
                        if (index < 6) {
                          return GestureDetector(
                            onTap: () {
                              _navigateToDetailScreen(4 + index);
                            },
                            child: AspectRatio(
                              aspectRatio: 0.9 / 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Hero(
                                      child: Container(
                                        child: ClipRRect(
                                          child: Image.asset(
                                            images[4 + index],
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      tag: images[4 + index],
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "${foodName[4 + index]}",
                                      style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      chefNames[4+index],
                                      style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                      separatorBuilder: (context, _) => SizedBox(width: 16,),
                      itemCount: 6),
                ),
                SizedBox(height: 20,),
                Text('Recommended',style: TextStyle(fontSize: 20,color: Colors.orange),),
                SizedBox(height: 10,),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: 6,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if(index < 16) {
                      return GestureDetector(
                        onTap: () {
                          _navigateToDetailScreen(10+index);
                        },
                        child: Hero(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.orange,
                              image: DecorationImage(
                                image: AssetImage(images[10+index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                foodName[10+index],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          tag: images[10+index],
                        ),
                      );
                    }
                    else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _navigateToDetailScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          chef: chefNames[index],
          image: images[index],
          name: foodName[index],
          calories: foodCalories[index],
          ingredients: foodIngrediants[index],
          time: foodTime[index],
          aboutRecipe: recipeDescription[index],
          cookingMethod: cookingMethod[index],
        ),
      ),
    );
  }
}