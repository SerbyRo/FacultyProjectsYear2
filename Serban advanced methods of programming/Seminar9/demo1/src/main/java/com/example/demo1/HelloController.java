package com.example.demo1;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;

public class HelloController {
    @FXML
    private Label welcomeText;
    private static int numar=0;

    @FXML
    private CheckBox checkBoxActive;

    @FXML
    protected void onIncrementButtonClick() {

        welcomeText.setText(String.valueOf(numar));
        numar++;
    }


    public void onActionActive(ActionEvent actionEvent) {
        if(checkBoxActive.isSelected())
            welcomeText.setText("Popescu este activ");
        else
            welcomeText.setText("Popescu este inactiv");
    }
}