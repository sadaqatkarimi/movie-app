import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviesapp_flutter/di/get_it.dart';
import 'package:moviesapp_flutter/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:moviesapp_flutter/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:moviesapp_flutter/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:moviesapp_flutter/presentation/journeys/drawer/navigation_drawer.dart';

import '../../widgets/app_error_widget.dart';
import 'movie_carousel/movie_carousel_widget.dart';
import 'movie_tabbed/movie_tabbed_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MovieCarouselBloc movieCarouselBloc;
  MovieBackdropBloc movieBackdropBloc;
  MovieTabbedBloc movieTabbedBloc;

  @override
  void initState() {
    super.initState();
    movieCarouselBloc = getItInstance<MovieCarouselBloc>();
    movieBackdropBloc = movieCarouselBloc.movieBackdropBloc;
    movieTabbedBloc = getItInstance<MovieTabbedBloc>();
    movieCarouselBloc.add(CarouselLoadEvent());
  }

  @override
  void dispose() {
    super.dispose();
    movieCarouselBloc?.close();
    movieBackdropBloc?.close();
    movieTabbedBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => movieCarouselBloc,
        ),
        BlocProvider(
          create: (context) => movieBackdropBloc,
        ),
        BlocProvider(
          create: (context) => movieTabbedBloc,
        ),
      ],
      child: Scaffold(
        drawer: const NavigationDrawer(),
        body: BlocBuilder<MovieCarouselBloc, MovieCarouselState>(
          cubit: movieCarouselBloc,
          builder: (context, state) {
            if (state is MovieCarouselLoaded) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FractionallySizedBox(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.6,
                    child: MovieCarouselWidget(
                      movies: state.movies,
                      defaultIndex: state.defaultIndex,
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.4,
                    child: MovieTabbedWidget(),
                  ),
                ],
              );
            } else if (state is MovieCarouselError) {
              return AppErrorWidget(
                onPressed: () => movieCarouselBloc.add(
                  CarouselLoadEvent(),
                ),
                errorType: state.errorType,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
