unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DateUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

type
  insNum = record
    ranInsAsc:integer;
    ranInsDesc:integer;
    sortedIns:integer;
end;

//random number generator
procedure RandomiseInsertion(var insertionArray:array of insNum; var timeBefore:TDATETIME);
var loop:integer;

begin
  timeBefore:=now;
  //generates a random list of N numbers not in order
  randomize;
           for loop:= 1 to 100 do
           begin
                insertionArray[loop].ranInsAsc:=random(100)+1;
                insertionArray[loop].ranInsDesc:=random(100)+1;
           end;
end;

//insertion sort ascending
procedure insertionSortAsc(var insertionArray:array of insNum; var beforeAsc,afterAsc:TDATETIME);
var outer,inner,temp:integer;

begin
  //find time before the array sorts
  beforeAsc:=now;
                 for outer:= 1 to 100 do
                 begin
                   temp:= insertionArray[outer].ranInsAsc;
                   inner:= outer;
                   while ((inner > 1) AND (insertionArray[inner-1].ranInsAsc > temp)) do
                   begin
                     insertionArray[inner].ranInsAsc:= insertionArray[inner-1].ranInsAsc;
                     inner:= inner-1;
                   end;
                   insertionArray[inner].ranInsAsc:=temp;
                 end;
  //find time after the array sorts
  afterAsc:=now;
end;

//insertion sort descending
procedure insertionSortDesc(var insertionArray:array of insNum; var beforeDesc,afterDesc:TDATETIME);
var outer,inner,temp:integer;

begin
  //find time before the array sorts
  beforeDesc:=now;
                 for outer:= 1 to 100 do
                 begin
                   temp:= insertionArray[outer].ranInsDesc;
                   inner:= outer;
                   while ((inner > 1) AND (insertionArray[inner-1].ranInsDesc < temp)) do
                   begin
                     insertionArray[inner].ranInsDesc:= insertionArray[inner-1].ranInsDesc;
                     inner:= inner-1;
                   end;
                   insertionArray[inner].ranInsDesc:=temp;
                 end;
  //find time after the array sorts
  afterDesc:=now;
end;
//binary search
procedure binarySearch(var insertionArray:array of insNum; var timeMiddle1,timeMiddle2,timeAfter:TDATETIME);
var left, right, num, current, answer, X, loop, numCounted:integer;
found:boolean;

begin
//get desired number from input box
timeMiddle1:=now;
X:=strToInt(inputbox('Choose number to find','Enter number',''));
timeMiddle2:=now;
numCounted:=0;

  //count how many times desired number appears
  for loop:= 1 to 100 do
  begin
    if (insertionArray[loop].ranInsAsc = X) then
    begin
      numCounted:=numCounted + 1;
    end;
  end;

//use binary search to find desired number
found:=false;
answer:=0;
if Length(insertionArray) = 0 then Exit;
left:=Low(insertionArray);
right:=High(insertionArray);
  while ((left <= right) AND (found = false)) do
  begin
    num:=left + ((right - left) div 2);
    current:= insertionArray[num].ranInsAsc;
    if (X = current) then
    begin
      answer:=current;
      found:=true;
    end;
    if (X > current) then
    left:= num + 1
    else
    right:= num - 1
  end;


if (answer = 0) then
   //if desired number does not appear in array
   form1.memo1.lines.add('There were ' + intToStr(numCounted) + ' matches for ' +intToStr(X))

else
    //if desired number does appear in array
   form1.memo1.lines.add(intToStr(answer) + ' was found ' + intToStr(numCounted) + ' times');

   timeAfter:=now;
end;

//write to file
procedure write(var insertionArray:array of insNum; beforeAsc,afterAsc,beforeDesc,afterDesc,timeBefore,timeMiddle1,timeMiddle2,timeAfter:TDATETIME);
var resultsAscFile, resultsDescFile, resultsTimeFile:textfile;
loop, diffMSAsc, diffMSDesc, diffSecAsc, diffSecDesc, diffMSTime1, diffMSTime2, diffMSTime3, diffMSTime4, diffSecTime1, diffSecTime2, diffSecTime3, diffSecTime4:integer;

begin
  //create files
  assignFile(resultsAscFile, 'resultsAsc.txt');
  assignFile(resultsDescFile, 'resultsDesc.txt');
  assignFile(resultsTimeFile, 'resultsTime.txt');
  reWrite(resultsAscFile);
  reWrite(resultsDescFile);
  reWrite(resultsTimeFile);

  //display time for ascending file
  writeLn(resultsAscFile, TimeToStr(beforeAsc) + ' ' + TimeToStr(afterAsc));
  diffMSAsc:=MilliSecondsBetween(beforeAsc,afterAsc);
  diffSecAsc:=SecondsBetween(beforeAsc,afterAsc);
  writeLn(resultsAscFile, 'It took ' + intToStr(diffMSAsc) + ' milliseconds to sort the array in ascending order');
  writeLn(resultsAscFile, 'It took ' + intToStr(diffSecAsc) + ' seconds to sort the array in ascending order');

  //display time for descending file
  writeLn(resultsDescFile, TimeToStr(beforeDesc) + ' ' + TimeToStr(afterDesc));
  diffMSDesc:=MilliSecondsBetween(beforeDesc,afterDesc);
  diffSecDesc:=SecondsBetween(beforeDesc,afterDesc);
  writeLn(resultsDescFile, 'It took ' + intToStr(diffMSDesc) + ' milliseconds to sort the array in descending order');
  writeLn(resultsDescFile, 'It took ' + intToStr(diffSecDesc) + ' seconds to sort the array in descending order');

  //display times
  writeLn(resultsTimeFile, 'Time when the program started running - ' + TimeToStr(timeBefore));
  writeLn(resultsTimeFile, 'Time when the program let you input a number - ' + TimeToStr(timeMiddle1));
  writeLn(resultsTimeFile, 'Time when the program received a number from input - ' + TimeToStr(timeMiddle2));
  writeLn(resultsTimeFile, 'Time when the program finished calculating - ' + TimeToStr(timeAfter));
  writeLn(resultsTimeFile, '');

  //display time until input box appears TIME 1
  diffMSTime1:=MilliSecondsBetween(timeBefore,timeMiddle1);
  diffSecTime1:=SecondsBetween(timeBefore,timeMiddle1);
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffMSTime1) + ' milliseconds until input box appears');
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffSecTime1) + ' seconds until input box appears');
  writeLn(resultsTimeFile, '');

  //display time for search to calculate TIME 2
  diffMSTime2:=MilliSecondsBetween(timeMiddle1,timeAfter);
  diffSecTime2:=SecondsBetween(timeMiddle1,timeAfter);
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffMSTime2) + ' milliseconds for search to calculate');
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffSecTime2) + ' seconds for search to calculate');
  writeLn(resultsTimeFile, '');

  //display time for whole program to run and finish TIME 3
  diffMSTime3:=MilliSecondsBetween(timeBefore,timeAfter);
  diffSecTime3:=SecondsBetween(timeBefore,timeAfter);
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffMSTime3) + ' milliseconds for whole program to run and finish');
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffSecTime3) + ' seconds for whole program to run and finish');
  writeLn(resultsTimeFile, '');

  //display time whilst the input box was open TIME 4
  diffMSTime4:=MilliSecondsBetween(timeMiddle1,timeMiddle2);
  diffSecTime4:=SecondsBetween(timeMiddle1,timeMiddle2);
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffMSTime4) + ' milliseconds whilst the input box was open');
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffSecTime4) + ' seconds whilst the input box was open');
  writeLn(resultsTimeFile, '');

  //calculate time for program to run excluding time spent with input box open
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffMSTime3 - diffMSTime4) + ' milliseconds to run excluding time spent with input box open');
  writeLn(resultsTimeFile, 'It took ' + intToStr(diffSecTime3 - diffSecTime4) + ' seconds to run excluding time spent with input box open');
  writeLn(resultsTimeFile, '');

  for loop:= 1 to 100 do
  begin
    //display the sorted arrays
    writeLn(resultsAscFile, intToStr(insertionArray[loop].ranInsAsc));
    writeLn(resultsDescFile, intToStr(insertionArray[loop].ranInsDesc));
  end;

  //close files
  closeFile(resultsAscFile);
  closeFile(resultsDescFile);
  closeFile(resultsTimeFile);

end;

//insertion sort program
procedure TForm1.Button1Click(Sender: TObject);
var insertionArray:array[1..100] of insNum;
beforeAsc,afterAsc,beforeDesc,afterDesc,timeBefore,timeMiddle1,timeMiddle2,timeAfter:TDateTime;

begin
     //declare parameters for functions and procedures
     RandomiseInsertion(insertionArray,timeBefore);
     insertionSortAsc(insertionArray,beforeAsc,afterAsc);
     insertionSortDesc(insertionArray,beforeDesc,afterDesc);
     binarySearch(insertionArray,timeMiddle1,timeMiddle2,timeAfter);
     write(insertionArray,beforeAsc,afterAsc,beforeDesc,afterDesc,timeBefore,timeMiddle1,timeMiddle2,timeAfter);
end;

end.

