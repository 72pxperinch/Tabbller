
// ------------------------------------------TABLES--------------------------------------------

double constrainedWidth = 0;
double clipNum = 0;

// -----------------------------------------FIREBASE-------------------------------------------

// List<int> sqrValues = FirebaseStorageObjectInterface
//     .instance.firebaseStorageObject!.learningProgresses[1]
//     .toMapTablePage();

// List<int> cubeValues = FirebaseStorageObjectInterface
//     .instance.firebaseStorageObject!.learningProgresses[2]
//     .toMapTablePage();

// List<int> primeValues = FirebaseStorageObjectInterface
//     .instance.firebaseStorageObject!.learningProgresses[3]
//     .toMapTablePage();

// ---------------------------------------TABLE CELLS------------------------------------------

List<int> selectedTables = List.generate(25, (index) {
  return index + 1;
});

List<int> topBar = List.generate(25, (index) {
  return index + 1;
});
List<int> centerBar = List.generate(625, (index) {
  return ((index ~/ 25) + 1) * ((index % 25) + 1);
});
List<int> sqrTopBar = List.generate(50, (index) {
  return index + 1;
});
List<int> sqrBottomBar = List.generate(50, (index) {
  return (index + 1) * (index + 1);
});
List<int> cubetopBar = List.generate(20, (index) {
  return index + 1;
});
List<int> cubeBottomBar = List.generate(20, (index) {
  return (index + 1) * (index + 1) * (index + 1);
});

List<int> primeBar = [
  2,
  3,
  5,
  7,
  9,
  11,
  13,
  15,
  17,
  19,
  21,
  23,
  25,
  27,
  29,
  31,
  33,
  35,
  37,
  39,
  41,
  43,
  45,
  47,
  49,
  51,
  53,
  55,
  57,
  59,
  61,
  63,
  65,
  67,
  69,
  71,
  73,
  75,
  77,
  79,
  81,
  83,
  85,
  87,
  89,
  91,
  93,
  95,
  97,
  99,
];

List<int> primeNumbers = [
  2,
  3,
  5,
  7,
  11,
  13,
  17,
  19,
  23,
  29,
  31,
  37,
  41,
  43,
  47,
  53,
  59,
  61,
  67,
  71,
  73,
  79,
  83,
  89,
  97
];

List<int> power1 = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8
];

List<int> power2 = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3];

List<int> power3 = [
  2,
  4,
  8,
  16,
  32,
  64,
  128,
  256,
  512,
  1024,
  2048,
  4096,
  3,
  9,
  27,
  81,
  243,
  729,
  2187,
  6561
];

// ----------------------------------------TIP BOX--------------------------------------------

List<String> multiTip = List.generate(625, (index) {
  return "Multiplication value Tip of  Table index $index";
});
List<String> sqrTip = List.generate(50, (index) {
  return "Square Number value Tip of  Table index $index";
});
List<String> cubeTip = List.generate(20, (index) {
  return "Cube Number value Tip of  Table index $index";
});
List<String> primeTip = List.generate(25, (index) {
  return "Prime Number value Tip of  Table index $index";
});
List<String> powerTip = List.generate(20, (index) {
  return "Ratio values Tip of  Table index $index";
});

Map<int,String> intToMonth = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "Jun",
  7: "Jul",
  8: "Aug",
  9: "Sep",
  10: "Oct",
  11: "Nov",
  12: "Dec",
};