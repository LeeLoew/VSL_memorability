function response = quiz_response(w, text, question_y, respkeys)
% add optional parameters -- time limit, etc

quitkey = KbName('return');

answer_y = question_y + 40;
answer_x = 100;
answer_wrapat = 500;
textcolor = [0 0 0];
KbName('UnifyKeyNames');
FlushEvents;
DrawFormattedText(w, text, 'center', question_y, textcolor);
  Screen('Flip', w);
while 1
            [keyDown, s, keyCodes] = KbCheck(-1);
            if keyDown
                if any(keyCodes(respkeys))
                    response = KbName(find(keyCodes));
                    return;
                end
            end
          
          
end
end