% prompt = {'Enter Subject Number:'};
% default = {'0'};
% title = 'Setup Info';
% LineNo = 1;
% answer = inputdlg(prompt,title,LineNo,default);
% [subjno_Str] = deal(answer{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Set Screen Parameters%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
quitkey = [KbName('q') KbName('p')];
spacekey = KbName('space');
[w, wrect] = Screen('OpenWindow', 0); HideCursor;
Screen('FillRect', w, [255 255 255]);
Screen('Flip',w);
% load the images and randomize assignment
rand('twister', sum(100*clock));






Screen('TextSize',w,24);

%%%%%%%%%%%%%%%%%%%%%%%%%%
qone = ['Please select one of the following responses using the keys 1 and 2:\n' ...
    '1. I noticed something about the experiment.\n' ...
    '2. I did not notice anything about the experiment.\n'];


qone_results = quiz_response(w, qone, wrect(4)/2-200,KbName({'1!','2@'}) );
    [keyDown, secs, keyCodes] = KbCheck(-1);
    while keyDown
        [keyDown, secs, keyCodes] = KbCheck(-1);
    end
    Screen('Flip', w); WaitSecs(1)

if qone_results == '1!';
    
freerespone = free_response(w, 'What did you notice? \n Begin typing your response, then \n press the enter key when finished. \n If your text reaches the end of a line \n do not press enter -- just let the text wrap around automatically. \n You may use backspace key to delete errors.', wrect(4)/2-100);

else
end
Screen('Flip', w); WaitSecs(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
qtwo = ['In the first part of the experiment, could \n you tell when you were going to get either a \n high (10 cent) or low (2 cent) reward? \n' ...
    'Please select one of the following responses using the keys 1 and 2:\n' ...
    '1. Yes.\n' ...
    '2. No.\n'];


qtwo_results = quiz_response(w, qtwo, wrect(4)/2-200,KbName({'1!','2@'}) );
    [keyDown, secs, keyCodes] = KbCheck(-1);
    while keyDown
        [keyDown, secs, keyCodes] = KbCheck(-1);
    end
    Screen('Flip', w); WaitSecs(1)
    
    
    if qtwo_results == '1!';
        freeresptwo = free_response(w, 'Please explain how you were able to tell if you were going to get a high or low reward in the space below \n Begin typing your response, then press the enter key when finished. \n If your text reaches the end of a line do not press enter -- just let the text wrap around automatically. \n You may use backspace key to delete errors.', wrect(4)/2-100);
    else
    end
    

[keyDown, secs, keyCodes] = KbCheck(-1);
while keyDown
    [keyDown, secs, keyCodes] = KbCheck(-1);
end
Screen('Flip', w); WaitSecs(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qthree = ['If you had to choose, what part of the experiment \n indicated a high or low reward? \n' ...
    'Please select one of the following responses using the keys 1 through 4:\n' ...
    '1. The orientation of the line segment.\n' ...
    '2. The color of the circle.\n' ...
    '3. I have no idea. \n' ...
    '4. It seemed random. \n'];


qthree_results = quiz_response(w, qthree, wrect(4)/2-200,KbName({'1!','2@','3#','4$'}) );
    [keyDown, secs, keyCodes] = KbCheck(-1);
    while keyDown
        [keyDown, secs, keyCodes] = KbCheck(-1);
    end
    Screen('Flip', w); WaitSecs(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if qthree_results == '2@';
        
       qfour = ['What color gave you a HIGH (10 cent) reward more often? \n' ...
    'Please select one of the following responses using the keys 1 and 2:\n' ...
    '1. Red.\n' ...
    '2. Green.\n'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
qthree_results = quiz_response(w, qfour, wrect(4)/2-200,KbName({'1!','2@'}) );
    [keyDown, secs, keyCodes] = KbCheck(-1);
    while keyDown
        [keyDown, secs, keyCodes] = KbCheck(-1);
    end
    Screen('Flip', w); WaitSecs(1)
    
    qfive = ['What color gave you a LOW (2 cent) reward more often? \n' ...
    'Please select one of the following responses using the keys 1 and 2:\n' ...
    '1. Red.\n' ...
    '2. Green.\n'];


qthree_results = quiz_response(w, qfive, wrect(4)/2-200,KbName({'1!','2@'}) );
    [keyDown, secs, keyCodes] = KbCheck(-1);
    while keyDown
        [keyDown, secs, keyCodes] = KbCheck(-1);
    end
    Screen('Flip', w); WaitSecs(1)
        
        
        
        
    else
    end
    

[keyDown, secs, keyCodes] = KbCheck(-1);
while keyDown
    [keyDown, secs, keyCodes] = KbCheck(-1);
end


























    cd Awareness_data
    save(['awareness_' num2str(subjno_Str) '.mat']);
    cd ..
    Screen('CloseAll')