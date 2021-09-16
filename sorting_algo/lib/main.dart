import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'algorithms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedAlgo;
  void chooseList() {
    setState(() {
      showDialog(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              title: Text('Select Sorting Algorithms'),
              content: CupertinoPicker(
                itemExtent: 32.0,
                onSelectedItemChanged: (selectedIndex) {
                  selectedAlgo = selectedIndex;
                },
                children: [
                  Text('Bubble Sort'),
                  Text('Selection Sort'),
                  Text('Radix Sort'),
                  Text('Bucket Sort'),
                  Text('Insertion Sort'),
                  Text('Quick Sort'),
                  Text('Count Sort'),
                  Text('Merge Sort'),
                  Text('Shell Sort'),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('Yes'),
                  onPressed: () {
                    setState(() {
                      appBarTitle = algoList[selectedAlgo];
                      Navigator.of(ctx).pop();
                      selector = selectedAlgo + 1;
                    });
                  },
                ),
                CupertinoDialogAction(
                  child: Text('No'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(ctx).pop();
                    });
                  },
                ),
              ],
            );
          });
    });
  }

  String appBarTitle = "Bubble Sort";
  List<int> _numbers = [];
  int sampleSize = 500;
  late StreamController<List<int>> _streamController;
  late Stream<List<int>> _stream;
  int changeValue = 1;
  int selector = 1;
  // Refactor Code..........
  _randomize() {
    _numbers = [];
    for (int i = 0; i < sampleSize; i++) {
      _numbers.add(Random().nextInt(sampleSize));
    }
    //setState(() {});
    _streamController.add(_numbers);
  }

  // Bubble Sort...............
  _bubbleSort() async {
    for (int i = 0; i < _numbers.length - 1; i++) {
      for (int j = 0; j < _numbers.length - 1 - i; j++) {
        if (_numbers[j] > _numbers[j + 1]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: 500));
        //setState(() {});
        _streamController.add(_numbers);
      }
    }
  }

// Selection Sort..............
  _selectionSort() async {
    int i, j, k;
    for (i = 0; i < _numbers.length - 1; i++) {
      for (j = k = i; j < _numbers.length; j++) {
        if (_numbers[j] < _numbers[k]) k = j;
      }
      int temp = _numbers[i];
      _numbers[i] = _numbers[k];
      _numbers[k] = temp;
      await Future.delayed(Duration(microseconds: 1000));
      _streamController.add(_numbers);
    }
  }

// Insertion Sort................
  _insertionSort() async {
    int j, x;
    for (int i = 1; i < _numbers.length; i++) {
      j = i - 1;
      x = _numbers[i];
      while (j > -1 && _numbers[j] > x) {
        _numbers[j + 1] = _numbers[j];
        j--;
        await Future.delayed(Duration(microseconds: 500));
        _streamController.add(_numbers);
      }
      _numbers[j + 1] = x;
    }
  }

// Quick Sort..........
  Future<int> partition(List<int> _numbers, int l, int h) async {
    int pivot = _numbers[h]; // pivot
    int i = (l - 1);

    for (int j = l; j <= h - 1; j++) {
      // If current element is smaller than the pivot
      if (_numbers[j] < pivot) {
        i++;
        int temp = _numbers[i];
        _numbers[i] = _numbers[j];
        _numbers[j] = temp;
      }
      await Future.delayed(Duration(microseconds: 1500));
      _streamController.add(_numbers);
    }
    int temp = _numbers[i + 1];
    _numbers[i + 1] = _numbers[h];
    _numbers[h] = temp;
    return (i + 1);
  }

  _quickSort(List<int> _numbers, int l, int h) async {
    if (l < h) {
      var pi = await partition(_numbers, l, h);
      _quickSort(_numbers, l, pi - 1);
      _quickSort(_numbers, pi + 1, h);
    }
  }

// Count Sort.............
  int findMax(List<int> _numbers, int n) {
    int max = _numbers.first;
    for (int i = 1; i < n; i++) {
      if (_numbers[i] > max) max = _numbers[i];
    }
    return max;
  }

  _countSort() async {
    int max = findMax(_numbers, _numbers.length);
    print("Maximum Number is: $max");
    int cLength = max + 1;
    print("cLength is: $cLength");
    List<int> c = [];
    for (int i = 0; i < cLength; i++) {
      c.add(0);
    }
    for (int i = 0; i < _numbers.length; i++) {
      c[_numbers[i]]++;
    }
    int k = 0, j = 0;
    while (k < cLength) {
      if (c[k] > 0) {
        _numbers[j++] = k;
        c[k]--;
      } else
        k++;

      await Future.delayed(Duration(microseconds: 1000));
      _streamController.add(_numbers);
    }
  }

// Merge Sort.............
  _merge(List<int> _numbers, int l, int mid, int h) async {
    int i, j, k = 0;
    i = l;
    j = mid + 1;
    List<int> C = [];
    for (int i = 0; i < h + 1; i++) C.add(0);
    while (i <= mid && j <= h) {
      if (_numbers[i] < _numbers[j]) {
        C[k++] = _numbers[i++];
      } else {
        C[k++] = _numbers[j++];
      }
    }
    if (i <= mid) {
      while (i <= mid) {
        C[k++] = _numbers[i++];
      }
    } else if (j <= h) {
      while (j <= h) {
        C[k++] = _numbers[j++];
      }
    }
    //Coping Elements...
    k = 0;
    for (int p = l; p <= h; p++) {
      _numbers[p] = C[k++];
    }
    setState(() {});
  }

  void mergeSort(List<int> _numbers, int s, int e) {
    if (s >= e) {
      return;
    }
    double d = (e + s) / 2;
    int mid = d.toInt();
    mergeSort(_numbers, s, mid);
    mergeSort(_numbers, mid + 1, e);
    _merge(_numbers, s, mid, e);
  }

  // Shell Sort
  void shellSort(List<int> _numbers, int n) async {
    int gap, i, j, temp;
    double d = n / 2;
    for (gap = d.toInt(); gap >= 1;) {
      double q = gap / 2;
      gap = q.toInt();
      for (i = gap; i < n; i++) {
        temp = _numbers[i];
        j = i - gap;
        while (j >= 0 && _numbers[j] > temp) {
          _numbers[j + gap] = _numbers[j];
          j = j - gap;
          await Future.delayed(Duration(microseconds: 1000));
          _streamController.add(_numbers);
        }
        _numbers[j + gap] = temp;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
    _randomize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(child: Text(appBarTitle)),
      ),
      body: Container(
        child: StreamBuilder<Object>(
            stream: _stream,
            builder: (context, snapshot) {
              int counter = 0;
              return Row(
                children: _numbers.map((int number) {
                  counter++;
                  return CustomPaint(
                    painter: BarPainter(
                        width: MediaQuery.of(context).size.width / sampleSize,
                        index: counter,
                        value: number),
                  );
                }).toList(),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbColor: Color(0xFFEB1555),
              activeTrackColor: Colors.blueAccent,
              inactiveTrackColor: Color(0xFF8D8E98),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
              overlayColor: Color(0x55EB1555),
            ),
            child: Slider(
              value: sampleSize.toDouble(),
              min: 100,
              max: 1000,
              divisions: 1000,
              label: sampleSize.round().toString(),
              onChanged: (double newValue) {
                setState(() {
                  sampleSize = newValue.round();
                  _randomize();
                });
              },
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                chooseList();
              });
            },
            child: const Icon(Icons.change_circle),
            backgroundColor: Colors.purple,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                  ),
                  onPressed: () {
                    _randomize();
                  },
                  child: Text(
                    "Randomize",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                  ),
                  onPressed: () {
                    if (selector == 1) {
                      _bubbleSort();
                    } else if (selector == 2) {
                      _selectionSort();
                    } else if (selector == 5) {
                      _insertionSort();
                    } else if (selector == 6) {
                      _quickSort(_numbers, 0, sampleSize - 1);
                    } else if (selector == 7) {
                      _countSort();
                    } else if (selector == 8) {
                      mergeSort(_numbers, 0, _numbers.length - 1);
                    } else if (selector == 9) {
                      shellSort(_numbers, _numbers.length);
                    }
                  },
                  child: Text(
                    "Sort",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  BarPainter({required this.width, required this.index, required this.value});
  final double width;
  final int index;
  final int value;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    if (this.value < 500 * .10) {
      //50
      paint.color = Colors.green;
    } else if (this.value < 500 * .20) {
      //100
      paint.color = Colors.yellow;
    } else if (this.value < 500 * .30) {
      //150
      paint.color = Colors.orange;
    } else if (this.value < 500 * .40) {
      //200
      paint.color = Colors.deepPurple;
    } else if (this.value < 500 * .50) {
      //250
      paint.color = Colors.lightBlueAccent;
    } else if (this.value < 500 * .60) {
      //300
      paint.color = Colors.pink;
    } else if (this.value < 500 * .70) {
      //350
      paint.color = Colors.grey;
    } else if (this.value < 500 * .80) {
      //400
      paint.color = Colors.purpleAccent;
    } else if (this.value < 500 * .90) {
      //450
      paint.color = Colors.green;
    } else if (this.value < 500 * 1) {
      //500
      paint.color = Colors.brown;
    } else if (this.value < 500 * 1.10) {
      //550
      paint.color = Colors.teal;
    } else {
      //1000
      paint.color = Colors.red;
    }
    paint.strokeWidth = width;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
