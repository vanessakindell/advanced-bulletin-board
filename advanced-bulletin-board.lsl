//Version 7.1

list Line1=["Use the NEXT and BACK buttons to navigate messages."];
list Line2=["If you want to create your own message,"];
list Line3=["select the NEW button at the bottom."];
list Line4=["Then select the row you want to add text to."];
list Line5=["The Sign Painter"];
integer post = 0;

string TempLine1;
string TempLine2;
string TempLine3;
string TempLine4;
integer targetLine = 0;
integer gListener;
key notecardQueryId;
integer notecardLine;
integer pinned = 0;

key entryPerson;

ShowEntry(integer post)
{
    llSetLinkPrimitiveParamsFast(1,[PRIM_TEXT,(string)(post+1)+"/"+(string)llGetListLength(Line1),<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(8,[PRIM_TEXT,llList2String(Line1,post),<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(9,[PRIM_TEXT,llList2String(Line2,post),<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(12,[PRIM_TEXT,llList2String(Line3,post),<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(11,[PRIM_TEXT,llList2String(Line4,post),<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(7,[PRIM_TEXT,"~"+llList2String(Line5,post),<1,1,1>,1]);
}
ShowTempLines()
{
    llSetLinkPrimitiveParamsFast(1,[PRIM_TEXT,"NEW ENTRY",<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(8,[PRIM_TEXT,TempLine1,<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(9,[PRIM_TEXT,TempLine2,<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(12,[PRIM_TEXT,TempLine3,<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(11,[PRIM_TEXT,TempLine4,<1,1,1>,1]);
    llSetLinkPrimitiveParamsFast(7,[PRIM_TEXT,"{FINISH}",<1,1,1>,1]);
}
UnescapeLists()
{
    list convertedLine1;
    list convertedLine2;
    list convertedLine3;
    list convertedLine4;
    list convertedLine5;
    
    integer a=0;
    for(a=0;a<llGetListLength(Line1);++a)
    {
        convertedLine1 = convertedLine1+llUnescapeURL(llList2String(Line1,a));
    }
    Line1 = convertedLine1;
    for(a=0;a<llGetListLength(Line2);++a)
    {
        convertedLine2 = convertedLine2+llUnescapeURL(llList2String(Line2,a));
    }
    Line2 = convertedLine2;
    for(a=0;a<llGetListLength(Line3);++a)
    {
        convertedLine3 = convertedLine3+llUnescapeURL(llList2String(Line3,a));
    }
    Line3 = convertedLine3;
    for(a=0;a<llGetListLength(Line4);++a)
    {
        convertedLine4 = convertedLine4+llUnescapeURL(llList2String(Line4,a));
    }
    Line4 = convertedLine4;
    for(a=0;a<llGetListLength(Line5);++a)
    {
        convertedLine5 = convertedLine5+llUnescapeURL(llList2String(Line5,a));
    }
    Line5 = convertedLine5;
}
EscapeLists()
{
    list convertedLine1;
    list convertedLine2;
    list convertedLine3;
    list convertedLine4;
    list convertedLine5;
    
    integer a=0;
    for(a=0;a<llGetListLength(Line1);++a)
    {
        convertedLine1 = convertedLine1+llEscapeURL(llList2String(Line1,a));
    }
    Line1 = convertedLine1;
    for(a=0;a<llGetListLength(Line2);++a)
    {
        convertedLine2 = convertedLine2+llEscapeURL(llList2String(Line2,a));
    }
    Line2 = convertedLine2;
    for(a=0;a<llGetListLength(Line3);++a)
    {
        convertedLine3 = convertedLine3+llEscapeURL(llList2String(Line3,a));
    }
    Line3 = convertedLine3;
    for(a=0;a<llGetListLength(Line4);++a)
    {
        convertedLine4 = convertedLine4+llEscapeURL(llList2String(Line4,a));
    }
    Line4 = convertedLine4;
    for(a=0;a<llGetListLength(Line5);++a)
    {
        convertedLine5 = convertedLine5+llEscapeURL(llList2String(Line5,a));
    }
    Line5 = convertedLine5;
}
exportChanges()
{
    llRemoveInventory("notes");
    EscapeLists();
    osMakeNotecard("notes",llList2CSV(Line1)+"\n"+llList2CSV(Line2)+"\n"+llList2CSV(Line3)+"\n"+llList2CSV(Line4)+"\n"+llList2CSV(Line5));
    UnescapeLists();
}
default
{
    state_entry()
    {
        if((integer)llGetObjectDesc()!=0)
        {
            pinned = (integer)llGetObjectDesc()-1;
            post = pinned;
        }
        if(llGetInventoryKey("notes") != NULL_KEY)
        {
            llSetText("",<1,1,1>,1);
            llSetLinkPrimitiveParamsFast(8,[PRIM_TEXT,"",<1,1,1>,1]);
            llSetLinkPrimitiveParamsFast(9,[PRIM_TEXT,"Loading",<1,1,1>,1]);
            llSetLinkPrimitiveParamsFast(12,[PRIM_TEXT,"Please Wait",<1,1,1>,1]);
            llSetLinkPrimitiveParamsFast(11,[PRIM_TEXT,"",<1,1,1>,1]);
            llSetLinkPrimitiveParamsFast(7,[PRIM_TEXT,"",<1,1,1>,1]);
            notecardQueryId = llGetNotecardLine("notes",notecardLine);
        }
        else
        {
            state main;
        }
    }
    dataserver(key query_id, string data)
    {
        if (query_id == notecardQueryId)
        {
            if (data == EOF)
            {
                UnescapeLists();
                state main;
            }
            else
            {
                notecardLine = notecardLine + 1;
                if(notecardLine == 1)
                {
                    Line1 = llCSV2List(data);
                }
                else if(notecardLine == 2)
                {
                    Line2 = llCSV2List(data);
                }
                else if(notecardLine == 3)
                {
                    Line3 = llCSV2List(data);
                }
                else if(notecardLine == 4)
                {
                    Line4 = llCSV2List(data);
                }
                else if(notecardLine == 5)
                {
                    Line5 = llCSV2List(data);
                }
                notecardQueryId = llGetNotecardLine("notes",notecardLine);
            }
        }
    }
}
state main
{
    state_entry()
    {
        ShowEntry(post);
    }
    timer()
    {
        llSetTimerEvent(0);
        post = pinned;
        ShowEntry(post);
    }
    touch_end(integer count)
    {
        llSetTimerEvent(180);
        integer entries = llGetListLength(Line1)-1;
        if(llDetectedLinkNumber(0)==10)
        {
            post = post + 1;
            if(post > entries)
            {
                post = 0;
            }
        }
        else if(llDetectedLinkNumber(0)==2)
        {
            post = post - 1;
            if(post < 0)
            {
                post = entries;
            }
        }
        else if(llDetectedLinkNumber(0)==7)
        {
            entryPerson = llDetectedKey(0);
            state NewEntry;
        }
        else if(llDetectedLinkNumber(0)==14)
        {
            if(llDetectedKey(0)==llGetOwner())
            {
                integer channel = (integer)llFrand(10000);
                gListener = llListen(channel, "", "", "");
                llDialog(llDetectedKey(0),"Delete post "+(string)(post+1),["Yes","No"],channel);
            }
            else
            {
                llRegionSayTo(llDetectedKey(0),0,"Sorry, only the owner can delete posts.");
            }
        }
        else if(llDetectedLinkNumber(0)==15)
        {
            if(llDetectedKey(0)==llGetOwner())
            {
                pinned = post;
                llSetObjectDesc((string)(post+1));
                llOwnerSay("Pinned post "+(string)(post+1));
            }
            else
            {
                llRegionSayTo(llDetectedKey(0),0,"Sorry, only the owner can pin posts.");
            }
        }
        ShowEntry(post);
    }
    listen(integer channel, string name, key id, string message)
    {
        if(id == llGetOwner())
        {
            if(message == "Yes")
            {
                llListenRemove(gListener);
                Line1 = llDeleteSubList(Line1,post,post);
                Line2 = llDeleteSubList(Line2,post,post);
                Line3 = llDeleteSubList(Line3,post,post);
                Line4 = llDeleteSubList(Line4,post,post);
                Line5 = llDeleteSubList(Line5,post,post);
                llOwnerSay("Deleted post "+(string)(post+1));
                post = post - 1;
                ShowEntry(post);
                exportChanges();
            }
        }
    }
}
state NewEntry
{
    state_entry()
    {
        targetLine = 0;
        TempLine1 = "Touch each line to set its message.";
        TempLine2 = "";
        TempLine3 = "";
        TempLine4 = "";
        ShowTempLines();
        llSetTimerEvent(600);
    }
    touch_end(integer count)
    {
        if(llDetectedKey(0)==entryPerson)
        {
            ShowTempLines();
            if(llDetectedLinkNumber(0)==8)
            {
                targetLine = 1;
                integer channel = (integer)llFrand(10000);
                gListener = llListen(channel, "", "", "");
                llSetLinkPrimitiveParamsFast(8,[PRIM_TEXT,"[ENTER TEXT]",<1,1,1>,1]);
                llTextBox(llDetectedKey(0), "Enter a note.", channel);
            }
            else if(llDetectedLinkNumber(0)==9)
            {
                targetLine = 2;
                integer channel = (integer)llFrand(10000);
                gListener = llListen(channel, "", "", "");
                llSetLinkPrimitiveParamsFast(9,[PRIM_TEXT,"[ENTER TEXT]",<1,1,1>,1]);
                llTextBox(llDetectedKey(0), "Enter a note.", channel);
            }
            else if(llDetectedLinkNumber(0)==12)
            {
                targetLine = 3;
                integer channel = (integer)llFrand(10000);
                gListener = llListen(channel, "", "", "");
                llSetLinkPrimitiveParamsFast(12,[PRIM_TEXT,"[ENTER TEXT]",<1,1,1>,1]);
                llTextBox(llDetectedKey(0), "Enter a note.", channel);
            }
            else if(llDetectedLinkNumber(0)==11)
            {
                targetLine = 4;
                integer channel = (integer)llFrand(10000);
                gListener = llListen(channel, "", "", "");
                llSetLinkPrimitiveParamsFast(11,[PRIM_TEXT,"[ENTER TEXT]",<1,1,1>,1]);
                llTextBox(llDetectedKey(0), "Enter a note.", channel);
            }
            else if(llDetectedLinkNumber(0)==7)
            {
                targetLine = 5;
                integer channel = (integer)llFrand(10000);
                gListener = llListen(channel, "", "", "");
                llDialog(llDetectedKey(0),"Finished?",["Yes","No","Cancel"],channel);
            }
        }
        else
        {
            llRegionSayTo(llDetectedKey(0),0,"Sorry, already in use.");
        }
    }
    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(gListener);
        if(targetLine==1)
        {
            TempLine1 = message;
        }
        else if(targetLine==2)
        {
            TempLine2 = message;
        }
        else if(targetLine==3)
        {
            TempLine3 = message;
        }
        else if(targetLine==4)
        {
            TempLine4 = message;
        }
        else if(targetLine==5)
        {
            if(message == "Yes")
            {
                Line1 = Line1 + TempLine1;
                Line2 = Line2 + TempLine2;
                Line3 = Line3 + TempLine3;
                Line4 = Line4 + TempLine4;
                Line5 = Line5 + llKey2Name(id);
                post = llGetListLength(Line1)-1;
                exportChanges();
                state main;
            }
            else if(message == "Cancel")
            {
                state main;
            }
        }
        targetLine = 0;
        ShowTempLines();
    }
    timer()
    {
        llRegionSayTo(entryPerson,0,"Entry timed out; saved note as is.");
        Line1 = Line1 + TempLine1;
        Line2 = Line2 + TempLine2;
        Line3 = Line3 + TempLine3;
        Line4 = Line4 + TempLine4;
        Line5 = Line5 + llKey2Name(entryPerson);
        post = llGetListLength(Line1)-1;
        exportChanges();
        state main;
    }
}
