Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173007pub.verizon.net ([206.46.173.7]:43003 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2CLBq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 21:46:29 -0400
Received: from vms170035 ([unknown] [192.168.1.3]) by vms173007.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0R005BH0XGO9C0@vms173007.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sun, 11 Mar 2012 20:46:28 -0500 (CDT)
Date: Sun, 11 Mar 2012 20:46:28 -0500 (CDT)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <22781504.258629.1331516788574.JavaMail.root@vms170035> (sfid-20120312_024658_902904_D4CB0B7C)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> On 03/11/12 8.19 PM, Larry Finger wrote:
> On 03/11/2012 05:36 PM, Alex wrote:

[ Previous Larry email:
After you boot it, use the NetworkManager system tray
applet to connect to your system.
Does that work? ]

> Alex (in answer to [Previous Larry email]):
> Yes. How? Very smoothly.

Unfortunately, here we lose the sync (so to speak):

>> I know that the openSUSE Live CD works on my computer with the Rosewill device 
>> and WEP encryption. That tells me that the driver is working correctly, and that 
>> the user-space stuff is OK. Let's see if we can find what is wrong for you.
>> After the Live CD boots, do you see the NM applet in the lower-right hand corner 
of the screen?
>> When you click on it, do you see a list of APs that are in range?
>> If you click on yours, do you get a screen that wants to know the WEP key? You 
>> will need to enter the hexadecimal key, not any passphrase. You will also get a 
>> popup asking if you want to use kwallet. Say yes and give it a blank password.
>> Did you get a connection? Note, NM uses wpa_supplicant even for WEP. That is normal.

I'm repeating myself:
> Yes. How? Very smoothly.

That means that I _must_ have done and succeeded in all of your above
instructions and descriptions.  But that's beside the point.

The real point that somehow I haven't been able to convey since my OP
is that I expect the commands,
iwconfig wlan0 essid ...

and

iwconfig wlan0 key restricted ... 
(or these two combined)

to work from the _command line_ (init 3) for an adapter/driver.
(how one actually connects to an AP, is _another_ story completely
and I can handle that by myself).

What you have to do to replicate what I (and all the other
users who prefer to sit at the command line) do is to
use Linux at command line (init 3) and test the two commands.

As an aside, in the meantime I tested Knoppix wireless in graphics mode.
Works smoothly as well (as I feared)!
Fails, as I said, if you try to connect from the command line, like
'knoppix 2' on the boot (BIOS) prompt.

I suppose openSUSE has a similar command to go directly to command line
(to "simulate" the _real_ Linux - not the graphics thrown on top of it).
A "workaround" I suppose is to start up openSUSE "normally" (to graphics
mode) _without_ the Rosewill plugged in (so the driver module doesn't
load automatically). Then go into a terminal, then plug in Rosewill
then test these two commands.

Reasons (pretty obvious):
1. Wired connections _can_ be made from the command line at any time
simply, conveniently and securely.
2. I worked with wireless adapters (Lynksys - Atheros? comes to mind)
which do indeed that (i.e. succeed on the above two commands).
Whether I use the wpa_supplicant (again, from command line) is based on
what the AP expects from me as level of security and that's my business.

Thanks,
-- Alex
