import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart';
import 'package:next_chat/app/modules/home/bloc/home_bloc.dart';
import 'package:next_chat/app/modules/home/widgets/users_tile.dart';
import 'package:next_chat/app/res/app_colors.dart';
import 'package:next_chat/app/routes/app_routes.dart';
import 'package:next_chat/app/utils/app_drawer.dart';
import 'package:next_chat/app/utils/app_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    debugPrint("CALLED HOME INIT");

    context.read<HomeBloc>().add(GetHomeDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),

      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogoutUserLoadingState) {
            AppLoader.showLoaderWithDialog();
          }
          if (state is UnauthenticatedState) {
            AppLoader.hideLoader();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Logout Successfully")),
            );
          }

          if (state is LogoutUserErrorState) {
            AppLoader.hideLoader();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: BlocConsumer<HomeBloc, HomeState>(
          buildWhen: (previous, current) => current is! HomeActionState,

          listener: (context, state) {
            if (state is GetHomeDataErrorState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },

          builder: (context, state) {
            if (state is GetHomeDataLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            if (state is GetHomeDataSuccessState) {
              final user = state.user;
              final isNoUserFound = state.isnoUserfoundtofiltered;

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, ${user?.name ?? "there"} 👋",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Start a conversation with your friends",

                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        onChanged: (value) {
                          debugPrint("VALUE TYPED IN SEARCH ::: $value");

                          context.read<HomeBloc>().add(
                            SearchUserEvent(query: value),
                          );
                        },

                        decoration: InputDecoration(
                          hintText: "Search people...",

                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),

                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),

                          filled: true,

                          fillColor: Theme.of(context).colorScheme.surface,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.2,
                            ),
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "People",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 10),

                      isNoUserFound
                          ? Center(
                              child: Text(
                                "No user found!",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: state.filteredusers.length,
                                physics: const AlwaysScrollableScrollPhysics(),

                                itemBuilder: (context, index) {
                                  return UsersList(
                                    user: state.filteredusers[index],
                                    onTap: () {
                                      context.push(
                                        AppRoutes.chat,
                                        extra: {
                                          "user": state.filteredusers[index],
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
