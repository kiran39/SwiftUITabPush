//
//  ContentView.swift
//  NotificationPOC8
//
//  Created by G Kiran Kumar on 09/09/20.
//  Copyright © 2020 G Kiran Kumar. All rights reserved.
//

import SwiftUI


struct ContentView: View {
 //   let todoPublisher = NotificationCenter.default.publisher(for: NSNotification.Name("Detail"))
    @State var show: Bool = false
    @State var selection = 1
    var body: some View {
        TabView(selection: $selection ) {
            FirtstView()
            .tabItem {
                Image(systemName: "1.circle")
                Text("First")
            }.tag(0)
                
            ListView(show: self.$show, selection: self.$selection)
           // ListView()
            .tabItem {
                Image(systemName: "2.circle")
                Text("Second")
            }.tag(1)
                
            
        }
//        .onReceive(todoPublisher) {notification in
//            self.show = true
//            self.selection = 1
//        }
    }
    
} 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    
    //MARK First View

struct FirtstView: View {
    var body: some View {
        NavigationView {
                      VStack {
                           VStack {
                                Button(action: {
                                        print("Requesting Permission")
                                        self.requestAutherization()
                                }){
                                Text("Request Permission")
                                }
                                Button(action: {
                                    print("Scheduling notificaion")
                                    self.requestNotification()
                                }){
                                Text("schedule notificaion")
                                }
                            }
                          
                          }
        .navigationBarTitle("First")
        }
    }
    
    //Request Authization
    func requestAutherization() {
                 UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                 if success{
                     print("Ready to take Notifications")
                 } else if let error = error {
                     print(error.localizedDescription)
                 }
             })
       }
    
    //Sechdule notification
    func requestNotification() {
        
        let content1 = UNMutableNotificationContent()
           content1.title = "This is local Notification"
           content1.body = "This is description of the notification."
           content1.sound = UNNotificationSound.default
        
           //show this notification five seconds from now
              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
           
           //choose a indentifier
             let request = UNNotificationRequest(identifier: UUID().uuidString, content: content1, trigger: trigger)
             
             UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
       }
    
}




    //MARK LIST View

struct ListView: View {
    @Binding var show: Bool
    @Binding var selection: Int
    //@State var show = false
    let todoPublisher = NotificationCenter.default.publisher(for: NSNotification.Name("Detail"))

    var body: some View {
        
        
        NavigationView {
            if self.show { NavigationLink(destination: DetailView(), isActive: self.$show){ Text("") }
            } else {
                List {
                        ForEach(0..<5) {data in
                            NavigationLink(destination: DetailView()) {
                                Text("Text for row \(data)")
                            }
                        }
                .navigationBarTitle("Notifications")
                }
            }
        }
        .onReceive(todoPublisher) {notification in
            self.show = true
            self.selection = 1
        }
    }
}
