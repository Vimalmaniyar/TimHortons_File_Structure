//
//  THStepper.swift
//  TeamHortons
//
//  Created by Magnatesage  on 03/12/22.
//

import Foundation
import UIKit
enum StepperType{
    case forVarient,forCusromise,forCart
}

struct ViewData {
  var sectionMaxValue:Int = 0
  var sectionMinValue: Int = 0
  var sectionCurrentTotal : Int = 0
  var sectionMaxSelected: Int = 0
  let color: UIColor
  var minimum: Double
  var maximum: Double
  let stepValue: Double
  let style : StepperType
}

class THStepper: UIControl {
  
  private lazy var plusButton = stepperButton(color: viewData.color, text: "+", value: 1)
  private lazy var minusButton = stepperButton(color: viewData.color, text: "-", value: -1)
    var indexPath: IndexPath?
    
  private lazy var counterLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
      label.layer.borderColor =  ThemeColors.titleGryColorRBI.getColor.cgColor

      switch viewData.style{
      case .forVarient:
          label.layer.borderWidth = 0
      case .forCusromise:
          label.layer.borderWidth = 1
      case .forCart:
          label.layer.borderWidth = 0
      }
    label.text = "\(Int(value))"
    return label
  }()
  
  private lazy var container: UIStackView = {
    let stack = UIStackView()
    stack.distribution = .fillEqually
    stack.spacing = 5
    stack.translatesAutoresizingMaskIntoConstraints = false
      switch viewData.style{
      case .forVarient:
          stack.layer.borderWidth = 1
      case .forCusromise:
          stack.layer.borderWidth = 0
      case .forCart:
          stack.layer.borderWidth = 0
      }
      stack.layer.borderColor = ThemeColors.titleGryColorRBI.getColor.cgColor
      stack.layer.cornerRadius = 5
    return stack
  }()
  
 
  private(set) var value: Double = 1
  private(set) var editedValue: Int = 0
  private var viewData: ViewData
  
  init(viewData: ViewData) {
    self.viewData = viewData
    super.init(frame: .zero)
    setup()
  }
    
    func getMaxValue() -> Int{
       return Int(self.viewData.maximum)
    }
    
    func resetValue(){
        value = 0
    }

    
    func updateNewData(viewData: ViewData) {
        self.viewData = viewData
        setup()
    }
    
    
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setValue(_ newValue: Double) {
      updateValue(min(viewData.maximum, max(viewData.minimum, newValue)))
  }
  func hideButtons() {
      plusButton.alpha = 0.5
      minusButton.alpha = 0.5
  }
    func hidePlusButton(){
        plusButton.alpha = 0.5
    }
    func hidMinusButton(){
        minusButton.alpha = 0.5
    }
    func showPlusButton() {
        plusButton.alpha = 1
    }
    func showMinusButton() {
        plusButton.alpha = 1
    }
  func showButtons() {
        plusButton.alpha = 1
        minusButton.alpha = 1
    }
  func updateMinMax(minimum:Double,maximum:Double){
        viewData.minimum = minimum
        viewData.maximum = maximum
      updateValue(min(viewData.maximum, max(viewData.minimum, value)))
    
  }
  private func setup() {
    backgroundColor = .white
    addSubview(container)
    
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: topAnchor),
      container.leadingAnchor.constraint(equalTo: leadingAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor),
      container.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    [minusButton, counterLabel, plusButton].forEach(container.addArrangedSubview)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    //plusButton.layer.cornerRadius = 0.5 * bounds.size.height
    //minusButton.layer.cornerRadius = 0.5 * bounds.size.height
  }
  
  private func didPressedStepper(value: Double) {
    updateValue(value * viewData.stepValue)
  }
  
    private func updateValue(_ newValue: Double) {
        
        guard (viewData.minimum...viewData.maximum) ~= (value + newValue) else {
            return
        }
        value += newValue
        if #available(iOS 15.0, *) {
            counterLabel.text = String(value.formatted())
        } else {
          // Fallback on earlier versions
          counterLabel.text = "\(value)"
        }
        if value == viewData.maximum && value == viewData.minimum{
            plusButton.alpha      = 0.5
            minusButton.alpha     = 0.5
            minusButton.isEnabled = false
            plusButton.isEnabled  = false
        }else if value >= viewData.maximum{
          plusButton.alpha      = 0.5
          minusButton.alpha     = 1
          minusButton.isEnabled = true
          plusButton.isEnabled  = false
        }else if value <= viewData.minimum{
          plusButton.alpha      = 1
          minusButton.alpha     = 0.5
          minusButton.isEnabled = false
          plusButton.isEnabled  = true
        }else{
          plusButton.alpha      = 1
          minusButton.alpha     = 1
          minusButton.isEnabled = true
          plusButton.isEnabled  = true
        }
        editedValue = Int(newValue)
        sendActions(for: .valueChanged)
//        self.sendActions(for: .touchUpInside)
  }
  
  
  private func stepperButton(color: UIColor, text: String, value: Int) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    button.setTitle(text, for: .normal)
    button.tag = value
      button.layer.borderColor = UIColor.lightGray.cgColor
      switch viewData.style{
      case .forVarient:
          button.layer.borderWidth = 0
      case .forCusromise:
          button.layer.borderWidth = 1
      case .forCart:
          button.layer.borderWidth = 0
      }
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(color.withAlphaComponent(0.5), for: .highlighted)
    button.backgroundColor = .clear
    return button
  }
  
  @objc private func buttonTapped(_ sender: UIButton) {
    didPressedStepper(value: Double(sender.tag))
      self.sendActions(for: .touchUpInside)
  }
}

