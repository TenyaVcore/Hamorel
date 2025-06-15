//
//  HomeView.swift
//  Hamorel
//
//  Created by 田川展也 on R 5/05/22.
//
import SwiftUI

struct HomeView: View {
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject var router: Router

    var body: some View {
        let bounds = UIScreen.main.bounds
        let screenHeight = Int(bounds.height)

        NavigationStack(path: $router.path) {
                VStack {
                    Spacer()

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    Text("Hamorel")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        

                    Spacer()

                    ZStack {
                        RoundedCorners(color: .white, tl: 20, tr: 20, bl: 0, br: 0)
                            .ignoresSafeArea()
                            .frame(height: (CGFloat(screenHeight) / 1.8))

                        VStack {
                            Text("ようこそ\(viewModel.name)さん")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.top, 10)

                            Text("友人家族と音楽で繋がろう")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.bottom, 30)

                            NavigationLink(value: NavigationLinkItem.create) {
                                ButtonView(text: "ルームを作成する", textColor: .white, buttonColor: Color("color_primary"))
                            }
                            .padding(.bottom, 20)

                            NavigationLink(value: NavigationLinkItem.enter) {
                                ButtonView(text: "ルームに参加する", textColor: .black, buttonColor: Color("color_secondary"))
                            }
                            .padding(.bottom, 10)

                            Divider()

                            NavigationLink(value: NavigationLinkItem.login) {
                                Text("ログイン")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(width: 300, height: 50)
                                    .background(Color("color_secondary"))
                                    .cornerRadius(10)
                            }
                            .padding(.vertical, 10)
                        }
                    }
                }
                .background {
                    Color("color_primary")
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(value: NavigationLinkItem.setting) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isPresentAppleMusicAuthView) {
                    AppleMusicAuthView()
                }
                .task {
                    await viewModel.onAppear()
                }
                .navigationDestination(for: NavigationLinkItem.self) { item in
                    router.navigate(item: item)
                }
            }
    }
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
            .environmentObject(Router())
    }
}
