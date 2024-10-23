//
//  ContentView.swift
//  Project7-iExpense
//
//  Created by suhail on 20/10/24.
//

import SwiftUI

struct ExpenseItem: Identifiable,Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

struct ExpenseFormatter: ViewModifier{
    var expenseAmount: Double
    
    func body(content: Content) -> some View {
        if expenseAmount<10{
            content
                .font(.system(size: 16,weight: .regular))
        }else if expenseAmount>=10 && expenseAmount<100{
            content
                .font(.system(size: 16,weight: .semibold))
        }else if expenseAmount>=100 && expenseAmount<1000{
            content
                .font(.system(size: 16,weight: .bold))
        }else{
            content
                .font(.system(size: 16,weight: .black))
        }
         
    }
    
}

extension View{
    func formatExpense(with amount: Double) -> some View{
        modifier(ExpenseFormatter(expenseAmount: amount))
    }
}

@Observable
class Expenses{
    var types = [String]()
    var items = [ExpenseItem](){
        didSet{
            if let encodedData = try? JSONEncoder().encode(items){
                UserDefaults.standard.setValue(encodedData, forKey: "Items")
            }
        }
    }
    init(){
        if let fetchedData = UserDefaults.standard.data(forKey: "Items"){
            if let decodedData = try? JSONDecoder().decode([ExpenseItem].self, from: fetchedData){
                items = decodedData
                types = Array(Set(decodedData.map{ $0.type }))
                return
                
            }
        }
        items = []
        types = []
    }
}



struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(expenses.types, id: \.self){ type in
                    Section(type){
                        var currentItems = expenses.items.filter{ $0.type == type }
                        
                        ForEach( currentItems) { expense in
                            HStack{
                                VStack(alignment: .leading){
                                    Text(expense.name)
                                        .font(.headline)
                                    Text(expense.type)
                                }
                                Spacer()
                                Text(expense.amount,format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .formatExpense(with: expense.amount)
                            }
                        }
                        .onDelete(perform: removeExpense)            }
                    .navigationTitle("iExpense")
                    .navigationBarTitleDisplayMode(.large)
                    
                    }
                   
                    }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            .toolbar{
                Button("Add Expense",systemImage: "plus"){
                   showingAddExpense = true
                }
                }
               
        }
    }
    func removeExpense(at offset: IndexSet){
        expenses.items.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}
