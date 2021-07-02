function VSL_mem_v1
%CATVL1
%
% 
% TJV 8/12/2016; 9/12/2016: added stage 2

% remove:
Screen('Preference', 'SkipSyncTests', 1);

% get input
answers = inputdlg({'SubID (#)'}, 'Inputs', 1, {'0'});

sub = str2num(answers{1});
    

% key assignment
KbName('UnifyKeyNames');
startKey = KbName('space');
quitKeys = [KbName('q') KbName('p')]; % hold both to quit
key1 = KbName('z');
key2 = KbName('m');

HideCursor; commandwindow;

datafile = ['data-' num2str(sub) '.mat'];

% trial timing (s)
imDur = 1; 
imITI = 1;

randseed = rng('shuffle');

% list of faces separated by 2 factors -- gender and race
imagefiles = cell(1,4); 
imagefiles{1} = Shuffle(dir('TaskImages/FH*.jpg'));
imagefiles{2} = Shuffle(dir('TaskImages/MH*.jpg'));
imagefiles{3} = Shuffle(dir('TaskImages/FL*.jpg')); %formerly interior
imagefiles{4} = Shuffle(dir('TaskImages/ML*.jpg')); %formerly exterior

% open/set up screen
[w,wrect] = Screen('OpenWindow', max(Screen('Screens')),[255 255 255]);
imRect = CenterRect([0 0 231 256], wrect);
ifi = Screen('GetFlipInterval', w);
fixRect = CenterRect([0 0 20 20],wrect); 
fixColor = [0 0 0];
fixCorrectColor = [0 255 0];
fixErrorColor = [255 0 0];

% 16 possible ways for one image to predict another (e.g., F->F, F->M, etc.
% etc.). I balance these so using multiple of 16...if want to limit
% transitions by type need to edit below code that assigns images to pairs.
% g
itemsPaired = 32; % 1/2 of this number is the number of pairs
itemsUnpaired = 0; % doesn't have to be this...can be zero...if divisible by 4 then equal # of each type 
nPairs = itemsPaired/2; 

nRepsPerBlock = 4;
trialsPerBlock = nRepsPerBlock*(itemsPaired+itemsUnpaired);

nBlocks = 6; 

% load in the stimuli -- not sure this is a good idea, depends on # of
% images used and amount of VRAM. If lagged, load image prior to each
% presentation instead
imEachType = itemsPaired/4 + itemsUnpaired/4;
for idx = 1:imEachType
    for jdx = 1:4
        imagetex(jdx, idx) = Screen('MakeTexture', w,  imread(['TaskImages/' imagefiles{jdx}(idx).name]));
    end
end
Screen('PreloadTextures',w,imagetex(:));

pairTypes = zeros(16,2); 
for idx = 1:4
    for jdx = 1:4
        pairTypes((idx-1)*4+jdx,:) = [idx jdx]; 
    end
end

imageTypes = zeros(itemsUnpaired + nPairs,4); % each unpaired image will get a unique ID, each paired image will get a shared ID

faceFileIdx = zeros(1,4); % indexes into the imagefiles / imagetex 
for idx = 1:itemsUnpaired
    imType = mod(idx-1,4)+1; 
    faceFileIdx(imType) = faceFileIdx(imType) + 1;
    imageTypes(idx, :) = [imType, faceFileIdx(imType), -1, -1]; % last columns are imType / fileID for predicted image; paired images only
end
for idx = (itemsUnpaired+1):(itemsUnpaired + nPairs)
    imType = pairTypes(mod(idx-1,16)+1,1);
    faceFileIdx(imType) = faceFileIdx(imType) + 1;
    imageTypes(idx, 1:2) = [imType, faceFileIdx(imType)];
    imType = pairTypes(mod(idx-1,16)+1,2);
    faceFileIdx(imType) = faceFileIdx(imType) + 1;
    imageTypes(idx, 3:4) = [imType, faceFileIdx(imType)];
end

targetPairs = imageTypes((itemsUnpaired+1):(itemsUnpaired + nPairs),:);
foilPairs = targetPairs; 

% create foil pairs. For each type of predictive image, recombine with
% unique 'predicted' image that is predicted by same class. This will
% ensure that there is an even balance of each predicting each other image
% type.
% determine possible orders where the item isn't predicting the same item
% as target pair
foilperms = perms(1:4);
for idx = 1:4
    foilperms(find(foilperms(:,idx)==idx),:) = [];
end
foilidx = 0;
for idx = 1:4
    % randomly select a foilperm
    thisperm = foilperms(randi(size(foilperms,1)),:);
    for jdx = 1:4
        foilidx = foilidx+1;
        foilPairs(foilidx, 3:4) = targetPairs((idx-1)*4+thisperm(jdx),3:4);
    end
end
        




DrawFormattedText(w,'You will see a series of faces. \n Your job is to press one button for male faces \n and another button for female faces. \n \n Please respond as accurately as possible because \n inaccurate responses will make the experiment take longer. \n \n Press spacebar to begin.','center','center',[0 0 0]);
 Screen('Flip',w);
 WaitSecs(2)
 [keyDown, secs, keyCodes] = KbCheck(-1);
    while ~keyCodes(startKey)
        [keyDown, secs, keyCodes] = KbCheck(-1);
        if all(keyCodes(quitKeys))
            sca; return;
        end
    end

data = zeros(nBlocks*trialsPerBlock, 9);

SINGLETON = 0; IMPAIR1 = 1; IMPAIR2 = 2; 

for block = 1:nBlocks
    
    % shuffle trial order for this block, guarantee no face or pair
    % repetition
    while 1
        pairedOrder = Shuffle(repmat(1:size(imageTypes,1),1, nRepsPerBlock));
        imageOrder = zeros(trialsPerBlock, 3);
        imOrderIdx = 1;
        for idx = 1:length(pairedOrder)
            if pairedOrder(idx) <= itemsUnpaired
                type = SINGLETON; 
            else
                type = IMPAIR1; 
            end
            imageOrder(imOrderIdx, :) = [imageTypes(pairedOrder(idx),1:2) type]; 
            imOrderIdx = imOrderIdx + 1;
            if imageTypes(pairedOrder(idx),3)~=-1
                imageOrder(imOrderIdx, :) = [imageTypes(pairedOrder(idx), 3:4) IMPAIR2];
                imOrderIdx = imOrderIdx + 1;
            end
        end
        % logic of this is confusing, but this next statement is a test for 
        % immediately repeated image, 2-back repeat, or immediately repeated pair
        if ~any((imageOrder(1:(end-1),2)==imageOrder(2:end,2)) & (imageOrder(1:(end-1),1)==imageOrder(2:end,1)) ) && ~any((imageOrder(1:(end-2),2)==imageOrder(3:end,2)) & (imageOrder(1:(end-2),1)==imageOrder(3:end,1)))
            break; 
        end
    end
    
    if block == 1
        DrawFormattedText(w,'If face: Press z for female, m for male.\n \nSpace to start.','center','center',[0 0 0]);

    else
        DrawFormattedText(w,'Block break, rest briefly if needed. \n Long breaks and inaccurate responses will result in the study going long. \nIf face: Press z for female, m for male.\n \nSpace to start.','center','center',[0 0 0]);

    end
    Screen('Flip',w);
    WaitSecs(1)

    [keyDown, secs, keyCodes] = KbCheck(-1);
    while ~keyCodes(startKey)
        [keyDown, secs, keyCodes] = KbCheck(-1);
        if all(keyCodes(quitKeys))
            sca; return;
        end
    end

    while keyCodes(startKey)
        [keyDown, secs, keyCodes] = KbCheck(-1);
    end
    Screen('FrameOval', w, fixColor, fixRect); 
    nextOnset = Screen('Flip', w) + imITI;
    
    for trial = 1:trialsPerBlock
        imType = imageOrder(trial, 1);
        imIdx = imageOrder(trial, 2); 
        trialType = imageOrder(trial, 3);
        
        if (imType == 1) || (imType == 3)
        	corResp = 1; 
        else
         	corResp = 2;
        end
        
        
        Screen('DrawTexture', w, imagetex(imType, imIdx),[],imRect);
        Screen('FrameOval', w, fixColor, fixRect); 
        imFlip = Screen('Flip', w, nextOnset - ifi/2);
        
        % check for response
        resp = -1; rt = -1; acc = 0;
        while (GetSecs - imFlip) < (imDur - ifi)
            [keyDown, secs, keyCodes] = KbCheck(-1);
            if keyDown 
                if keyCodes(key1) 
                    resp = 1;
                    rt = secs - imFlip;
                    acc = (corResp == resp);
                    break;
                elseif keyCodes(key2) 
                    resp = 2;
                    rt = secs - imFlip;
                    acc = (corResp == resp);
                    break;
                elseif all(keyCodes(quitKeys))
                    save(datafile); Screen('Close', imagetex(:)); sca; return;
                end
            end
        end
        
        if resp ~= -1
            Screen('DrawTexture', w, imagetex(imType, imIdx),[],imRect);
            if acc
                Screen('FillOval', w, fixCorrectColor, fixRect);
            else
                Screen('FillOval', w, fixErrorColor, fixRect); 
            end
            Screen('Flip', w);
        end
        
        % start blank interval, continue to monitor for resp if none
        % received
        nextOnset = imFlip + imDur;
        if resp == -1
            Screen('FrameOval', w, fixColor, fixRect); 
        else
            if acc
                Screen('FillOval', w, fixCorrectColor, fixRect);
            else
                Screen('FillOval', w, fixErrorColor, fixRect); 
            end
        end
        imDown = Screen('Flip', w, nextOnset - ifi/2);
        while ((GetSecs - imDown) < (imITI - ifi)) && (resp == -1)
            [keyDown, secs, keyCodes] = KbCheck(-1);
            if keyDown 
                if keyCodes(key1) 
                    resp = 1;
                    rt = secs - imFlip;
                    acc = (corResp == resp);
                    break;
                elseif keyCodes(key2) 
                    resp = 2;
                    rt = secs - imFlip;
                    acc = (corResp == resp);
                    break;
                elseif all(keyCodes(quitKeys))
                    save(datafile); sca; Screen('Close', imagetex(:)); return;
                end
            end
        end
        
        if resp ~= -1
            if acc
                Screen('FillOval', w, fixCorrectColor, fixRect);
                Screen('Flip',w);
                WaitSecs(.2)
            else
                Screen('FillOval', w, fixErrorColor, fixRect);
                Screen('Flip',w);
                WaitSecs(.2)
                Screen('Flip',w);
                WaitSecs(.2)
            end
        elseif resp == -1
            Screen('FillOval', w, fixErrorColor, fixRect);
            Screen('Flip',w);
            WaitSecs(.2)
            Screen('Flip',w);
            WaitSecs(.2)
        end
        
        nextOnset = imDown + imITI; 
       
        % log data
        data((block-1)*trialsPerBlock+trial, :) = [sub block trial trialType imType imIdx corResp acc rt];
    end      
end
save(datafile);





vsl_awareness;

% now do stage 2 -- here, show a target and foil pair, then force choice
% which is more familiar
% we have 16 target pairs and 16 foil pairs. 
% each will appear in 4 recognition trials, once as first pair and once as
% second pair
% 16x4 = 64 trials total. This stage will likely take about 10 minutes,
% perhaps longer.


%  instructions
recInst = ['You are now entering the last stage of the experiment.\n' ...
           'You may or may not have noticed, but some images ALWAYS\npredicted other images in the sequence you just experienced.\n' ...
           'That is, 16 particular face images were ALWAYS\nfollowed by the same face.\n' ...
           'In this last stage, we are going to show you two pairs\non each trial, Sequence 1 and Sequence 2, in succession.\n' ...
           'Your task is to pick which was the sequence that appeared\nduring the task. There is always a correct answer.\n' ...
           'Half the pairs are new, but will repeat during this stage.\nAlways pick the pair that appeared together during the task you just finished.\n' ...
           'You must make a response on every trial. If you are unsure\non any or all trials, that is OK, but please GO WITH YOUR GUT when you are not sure.\n' ...
           'If you would like additional clarification, please go speak with the experimenter now.' ...
           '\n\nTo proceed, please press the Y key to indicate \nthat you understand these instructions. '];

       
DrawFormattedText(w, recInst, 100, 'center', [0 0 0]);
recInstUpTime = Screen('Flip',w);
WaitSecs(2)
% determine combos / trial order
recogReps = 4; 
numRecTrials = 16*recogReps;
% lazily match target pairs with unique foil pairs, and guarantee no
% immediate trial repetitions of foil or target
% takes only a few seconds on my macbook, should finish while they view
% instructions
while 1
    % guarantee no immediately repeated target pair presentations
    while 1
        targetOrder = Shuffle(repmat(1:length(targetPairs), 1, recogReps));
        if ~any(targetOrder(1:(end-1))==targetOrder(2:end))
            break;
        end
    end
    % guarantee no immediately repeated foil pair presentations
    while 1
        foilOrder = Shuffle(repmat(1:length(foilPairs), 1, recogReps));
        if ~any(foilOrder(1:(end-1))==foilOrder(2:end))
            break;
        end
    end
    % guarantee no repeated combinations of target/foil pairs
    % make a unique number based on target / foil combos
    comboTypes = (targetOrder-1).*16+foilOrder;
    if length(unique(comboTypes))==length(comboTypes)
        break;
    end
end
    

while GetSecs - recInstUpTime < 5 
end

while 1
    [keyDown, secs, keyCodes] = KbCheck(-1);
    if keyDown
        if keyCodes(KbName('y'))
            break;
        end
    end
end

orderOrder = Shuffle(repmat(1:2, 1, numRecTrials/2));

recData = zeros(numRecTrials, 12); % CHECK THIS, correct # columns?

seqLabelDur = 0.5; % used for both the duration of the 'Sequence N' label and the blank period that follows

for recTrial = 1:numRecTrials
    thisOrder = orderOrder(recTrial);
    
    targ1ImType = targetPairs(targetOrder(recTrial),1); % indexes the target image class
    targ1ImIdx = targetPairs(targetOrder(recTrial),2);  % indexes specific image within that class
    targ2ImType = targetPairs(targetOrder(recTrial),3); 
    targ2ImIdx = targetPairs(targetOrder(recTrial),4); 
    
    foil1ImType = foilPairs(foilOrder(recTrial),1);
    foil1ImIdx = foilPairs(foilOrder(recTrial),2); 
    foil2ImType = foilPairs(foilOrder(recTrial),3);
    foil2ImIdx = foilPairs(foilOrder(recTrial),4); 
    
    DrawFormattedText(w, 'Get ready! Press space bar to start the next trial.', 'center', 'center', [0 0 0]);
    Screen('Flip', w); 
    
    while 1
        [keyDown, secs, keyCodes] = KbCheck(-1);
        if keyDown 
            if keyCodes(KbName('space'))
                break;
                elseif all(keyCodes(quitKeys))
                    save(datafile); Screen('Close', imagetex(:)); sca; return;
                
            end
        end
    end
    
    % show "Sequence 1"
    DrawFormattedText(w, 'Sequence 1', 'center', 'center', [0 0 0]);
    flipTime = Screen('Flip', w); 
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + seqLabelDur - ifi/2); 
    
    Screen('FrameOval', w, fixColor, fixRect);
    if thisOrder == 1 % target comes first
        Screen('DrawTexture', w, imagetex(targ1ImType, targ1ImIdx),[],imRect);
    else
        Screen('DrawTexture', w, imagetex(foil1ImType, foil1ImIdx),[],imRect);
    end
    flipTime = Screen('Flip', w, flipTime + seqLabelDur - ifi/2); 
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + imDur - ifi/2);
    
    Screen('FrameOval', w, fixColor, fixRect);
    if thisOrder == 1
        Screen('DrawTexture', w, imagetex(targ2ImType, targ2ImIdx),[],imRect);
    else
        Screen('DrawTexture', w, imagetex(foil2ImType, foil2ImIdx),[],imRect);
    end
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2);
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + imDur - ifi/2);
    
    % show "Sequence 2"
    DrawFormattedText(w, 'Sequence 2', 'center', 'center', [0 0 0]);
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2); 
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + seqLabelDur - ifi/2); 
    
    Screen('FrameOval', w, fixColor, fixRect);
    if thisOrder == 2 
        Screen('DrawTexture', w, imagetex(targ1ImType, targ1ImIdx),[],imRect);
    else
        Screen('DrawTexture', w, imagetex(foil1ImType, foil1ImIdx),[],imRect);
    end
    flipTime = Screen('Flip', w, flipTime + seqLabelDur - ifi/2); 
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + imDur - ifi/2);
    
    Screen('FrameOval', w, fixColor, fixRect);
    if thisOrder == 2
        Screen('DrawTexture', w, imagetex(targ2ImType, targ2ImIdx),[],imRect);
    else
        Screen('DrawTexture', w, imagetex(foil2ImType, foil2ImIdx),[],imRect);
    end
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2);

    DrawFormattedText(w, 'Which was more familiar from the first stage of the experiment? \nPress 1 for the first sequence, 2 for the other sequence. \nIf unsure, go with your gut feeling.', 'center', 'center', [0 0 0]);
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2); 
    
    while 1
        [keyDown, secs, keyCodes] = KbCheck(-1); 
        if keyDown
            if keyCodes(KbName('1!')) || keyCodes(KbName('1'))
                resp = 1; break;
            elseif keyCodes(KbName('2@')) || keyCodes(KbName('2'))
                resp = 2; break; 
                elseif all(keyCodes(quitKeys))
                    save(datafile); Screen('Close', imagetex(:)); sca; return;
                
            end
        end
    end
    acc = (resp == thisOrder);
    rt = secs - flipTime;
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2);
    
    % record data
    recData(recTrial,:) = [targ1ImType targ1ImIdx targ2ImType targ2ImIdx foil1ImType foil1ImIdx foil2ImType foil2ImIdx thisOrder resp acc rt];
end

save(datafile);

Screen('Close', imagetex(:));
sca; 
end

