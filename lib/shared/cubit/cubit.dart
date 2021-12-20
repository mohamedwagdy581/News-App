import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/sports/sports_screen.dart';
import 'package:news_app/shared/cubit/states.dart';

import '../../modules/business/business_screen.dart';
import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = const [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.business,
        ),
        label: 'Business'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.sports,
        ),
        label: 'Sports'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.science,
        ),
        label: 'Science'),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) {
      getSports();
    }
    if (index == 2) {
      getScience();
    }
    emit(NewsBottomNavState());
  }

  List<Widget> screens = const [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  List<String> titles = [
    'News Screen',
    'Sports Screen',
    'Science Screen',
  ];

  // Business
  List<dynamic> business = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'business',
        'apikey': '65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then(
      (value) {
        // print(value.data['articles'][0]['title']);
        business = value.data['articles'];
        print(business[2]['title']);
        emit(NewsGetBusinessSuccessState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(NewsGetBusinessErrorState(error.toString()));
      },
    );
  }

  // Sports
  List<dynamic> sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingState());

    if (sports.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'sports',
          'apikey': '65f7f556ec76449fa7dc7c0069f040ca',
        },
      ).then(
        (value) {
          // print(value.data['articles'][0]['title']);
          sports = value.data['articles'];
          //print(sports[2]['title']);
          emit(NewsGetSportsSuccessState());
        },
      ).catchError(
        (error) {
          print(error.toString());
          emit(NewsGetSportsErrorState(error.toString()));
        },
      );
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  // Science
  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingState());

    if (science.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'science',
          'apikey': '65f7f556ec76449fa7dc7c0069f040ca',
        },
      ).then(
        (value) {
          // print(value.data['articles'][0]['title']);
          science = value.data['articles'];
          // print(science[2]['title']);
          emit(NewsGetScienceSuccessState());
        },
      ).catchError(
        (error) {
          print(error.toString());
          emit(NewsGetScienceErrorState(error.toString()));
        },
      );
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  // Search
  List<dynamic> search = [];

  void getSearch(String value) {
    emit(NewsGetSearchLoadingState());

    search = [];

    DioHelper.getData(
      url: 'v2/everything',
      query: {
        'q': value,
        'apikey': '65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then(
      (value) {
        // print(value.data['articles'][0]['title']);
        search = value.data['articles'];
        // print(search[2]['title']);
        emit(NewsGetSearchSuccessState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(NewsGetSearchErrorState(error.toString()));
      },
    );
  }

  // Toggle between Dark and Light mode
  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
    } else {
      isDark = !isDark;
    }

    CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
      emit(NewsChangeModeState());
    });
  }
}
