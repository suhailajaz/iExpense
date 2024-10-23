//
//  AddView.swift
//  Project7-iExpense
//
//  Created by suhail on 21/10/24.
//

import SwiftUI
enum expenseType: String,CaseIterable{
    case personal = "Personal"
    case business = "Business"
    case miscellaneous = "Miscellaneous"

}

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var  type = expenseType.business.rawValue
    @State private var amount = 0.0
    var expenses: Expenses
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name",text: $name)
                
                Picker("Type", selection: $type){
                    let types = expenseType.allCases.map{$0.rawValue}
                    ForEach(types, id: \.self){
                        Text($0)
                    }
                }
                
                TextField("Amount",value: $amount, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new Expense")
            .toolbar{
                Button("Save"){
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
            
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
