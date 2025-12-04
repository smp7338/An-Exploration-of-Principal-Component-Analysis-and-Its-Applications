% Flight Test Dataset
X = [12.1 1.8 94  0.42 1.9;
     11.4 1.3 89  0.40 2.5;
     13.2 2.1 102 0.48 1.4;
     12.9 2.0 99  0.52 1.6;
     10.7 1.0 87  0.33 3.1;
     14.0 2.4 105 0.58 1.2;
     13.7 2.2 103 0.55 1.3;
     11.1 1.4 88  0.37 2.7;
     12.5 1.9 96  0.47 1.8;
     10.9 1.1 86  0.35 3.0];

varNames = ["Air Speed (m/s)","Climb Rate (m/s)","Power (W)", ...
            "Vibration (m/s^2)","Yaw Error (deg/s)"];

% Save dataset to a .mat file
save('flight_test_data.mat','X','varNames');
