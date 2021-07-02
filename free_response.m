function input_text = free_response(w, text, question_y)
% add optional parameters -- time limit, etc

input_text = [];
quitkey = KbName('return');

answer_y = question_y + 300;
answer_x = 100;
answer_wrapat = 40;
textcolor = [0 0 0];
KbName('UnifyKeyNames');
FlushEvents;
while 1
DrawFormattedText(w, text, 'center', question_y, textcolor);
            [keyDown, s, keyCodes] = KbCheck(-1);
            if keyDown
                if keyCodes(KbName('backspace'))
                    if length(input_text) > 0
                        input_text = input_text(1:(end-1));
                    end
                    while keyDown
                        [keyDown, s, keyCodes] = KbCheck(-1);
                    end
                    FlushEvents;
                    
                end
                if (keyCodes(quitkey))
                        break;
                    end
            end
            if CharAvail
                input_text = [input_text, GetChar];
            end
            DrawFormattedText(w, input_text, answer_x, answer_y, textcolor, answer_wrapat);
            Screen('Flip', w);
end
end