//
//  ContentView.swift
//  dentaku.App
//
//  Created by 森中恒希 on 2022/12/25.
//

import SwiftUI

enum CaluculateState {
    case initial, addition, substraction, division, multiplication, sum
}

struct ContentView: View {
    
   @State  var selectedItem: String = "0"
    @State  var calucuculatedNumber: Double = 0
   @State  var caluculateState: CaluculateState = .initial
    
    private let calucuculateItems: [[String]] = [
        ["AC","+/-","%","÷"],
        ["7","8","9","X"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="],
    ]
    
      var body: some View {
        
        ZStack {
            
            Color.gray
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Text(selectedItem  == "0" ? checkdecimal(number: calucuculatedNumber) : selectedItem)
                        .font(.system(size: 100, weight: .light))
                        .foregroundColor(Color.white)
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                
                VStack {
                    ForEach(calucuculateItems, id: \.self) { items in
                        NumberView(selectedItem: $selectedItem,
                                   caluculatedNumber: $calucuculatedNumber,
                                   caluculateState: $caluculateState,
                                   items: items)
                    }
                }
            }
        }
        
    }
  
    //小数点以下に数値が含まれるか確認する
    private func checkdecimal(number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne) {
            return String(Int(number))
        } else {
            return String(number)
        }
    }
}

struct NumberView: View {
    
    @Binding  var selectedItem: String
    @Binding  var caluculatedNumber: Double
    @Binding  var caluculateState: CaluculateState
    
    var items: [String]
    
    private let buttonWidth:CGFloat = (UIScreen.main.bounds.width - 50) / 4
    
    private let numbers: [String] = ["1","2","3","4","5","6","7","8","9","0","."]
    private let symbols: [String] = ["÷", "X", "-", "+", "="]
    
    var body: some View {
        
        HStack {
            
            ForEach( items, id: \.self) { item in
                
                Button {
                    handleButtonInfo(item: item)
                } label: {
                    Text(item)
                        .font(.system(size: 30, weight: .regular))
                        .frame(minWidth: 0, maxWidth: .infinity,                          minHeight: 0, maxHeight: .infinity)
                }
                .foregroundColor(numbers.contains(item) || symbols.contains(items) ? .white : .black)
                .background(handlebuttoncolor(item: item))
                .frame(width: item  == "0" ? buttonWidth * 2 + 10 :
                        buttonWidth)
                .cornerRadius(buttonWidth)
                
            }
            .frame(height: buttonWidth)
        }
    }
    
    //ボタンの色を設定
    private func handlebuttoncolor(item: String) -> Color {
        if numbers.contains(item) {
            return Color(white: 0.2, opacity: 1)
        } else if symbols.contains(item) {
            return Color.orange
        } else {
            return Color(white: 0.8, opacity: 1)
        }
    }
    
    //ボタンタップ時の処理を作成
    private func handleButtonInfo(item: String) {
        
        //数字が入力された時
        if numbers.contains(item) {
            // "入力されて、かつ入力済みの値に"."が含まれるもしくは"0"場合は、追加しない。
            if item == "." && (selectedItem.contains(".") || selectedItem.contains("0")) {
                return
            }
            
            //入力可能文字数を１０桁位に
            if selectedItem.count >= 10 {
                return
            }
            
            //数値が0のときは書き換える
            if selectedItem == "0"{
                selectedItem = item
                return
            }
            
            selectedItem += item
        } else if item == "AC" {
            selectedItem = "0"
            caluculatedNumber = 0
            caluculateState = .initial
        }
        
        guard let selectedNumber = Double(selectedItem) else { return }
        //計算記号が入力された時
        if item ==  "÷" {
            setCaluculate(state: .division, selectedNumber: selectedNumber)
        }else if item ==  "X" {
            setCaluculate(state: .multiplication, selectedNumber: selectedNumber)
        }else if item ==  "-" {
            setCaluculate(state: .substraction, selectedNumber: selectedNumber)
        }else if item ==  "+" {
            setCaluculate(state: .addition, selectedNumber: selectedNumber)
        }else if item ==  "=" {
            selectedItem = "0"
            caluculate(selectedNumber: selectedNumber)
            caluculateState = .sum
        }
    }
        //どの計算をするかハンドル
        private func setCaluculate(state: CaluculateState, selectedNumber: Double) {
            if selectedItem == "0" {
                caluculateState = state
                return
            }
            
            selectedItem = "0"
            caluculateState = state
            caluculate(selectedNumber: selectedNumber)
        }
        
    
    //計算する
    private func caluculate(selectedNumber: Double) {
        
        if caluculatedNumber == 0 {
            caluculatedNumber = selectedNumber
            return
        }
        
        switch caluculateState {
        case .addition:
            caluculatedNumber = caluculatedNumber + selectedNumber
        case .substraction:
            caluculatedNumber = caluculatedNumber - selectedNumber
        case .division:
            caluculatedNumber = caluculatedNumber / selectedNumber
        case .multiplication:
            caluculatedNumber = caluculatedNumber * selectedNumber
        default:
            break
       
        }
            
        }
    
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
