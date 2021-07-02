

Screen('Flip',w);
% load the images and randomize assignment
%rand('twister', sum(100*clock));

Screen('TextSize',w,24);

%%%%%%%%%%%%%%%%%%%%%%%%%%
qone = ['Please select one of the following responses using the keys 1 and 2:\n' ...
    '1. I have participated in an experiment like this before.\n' ...
    '2. I have not participated in an experiment like this before.\n'];


qone_results = quiz_response(w, qone, wrect(4)/2-200,KbName({'1!','2@'}) );
[keyDown, secs, keyCodes] = KbCheck(-1);
while keyDown
    [keyDown, secs, keyCodes] = KbCheck(-1);
end
Screen('Flip', w); WaitSecs(1)





qonepointfive = ['Please select one of the following responses using the keys 1 and 2:\n' ...
    '1. I noticed something about how the images appeared.\n' ...
    '2. I did not notice anything about how the images appeared.\n'];


qonepointfive_results = quiz_response(w, qonepointfive, wrect(4)/2-200,KbName({'1!','2@'}) );
[keyDown, secs, keyCodes] = KbCheck(-1);
while keyDown
    [keyDown, secs, keyCodes] = KbCheck(-1);
end
Screen('Flip', w); WaitSecs(1)

if qonepointfive_results == '1!';
    
    freerespone = free_response(w, 'What did you notice? \n Begin typing your response, then \n press the enter key when finished. \n If your text reaches the end of a line \n do not press enter -- just let the text wrap around automatically. \n You may use backspace key to delete errors.', wrect(4)/2-100);
    
else
end
Screen('Flip', w); WaitSecs(1)









qtwo = ['Did you notice that the images \n appeared in \n :\n' ...
    '1. Randomly (no pattern)\n' ...
    '2. Pairs\n' ...
    '3. Triplets\n' ...
    '4. Quadruplets\n' ...
    '5. Quintuplets\n' ];


qtwo_results = quiz_response(w, qtwo, wrect(4)/2-200,KbName({'1!','2@','3#', '4$','5%' }) );
[keyDown, secs, keyCodes] = KbCheck(-1);
while keyDown
    [keyDown, secs, keyCodes] = KbCheck(-1);
end
Screen('Flip', w); WaitSecs(1)






   save(datafile);
   % cd ..

    
    
    