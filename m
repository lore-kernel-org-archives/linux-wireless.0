Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37066 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab0G3JLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 05:11:11 -0400
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by gateway1.messagingengine.com (Postfix) with ESMTP id 6A5BA16DE44
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jul 2010 05:11:10 -0400 (EDT)
Message-Id: <1280481070.32016.1387484907@webmail.messagingengine.com>
From: "giovanni_re" <john_re@fastmail.us>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: CiscoLinksys AE1000 usb wifi N Dual Band adapter on a KUbuntu 10.4
 Howto Thoughts Issues ; jor linux-wireless
Date: Fri, 30 Jul 2010 02:11:10 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Today I will be installing a Cisco/Linksys AE1000 usb wifi N Dual Band
adapter on a KUbuntu 10.4 system on an ~ 2004 Compaq laptop.  Then I
will be attempting to see if I can get network access through that hw.
http://homestore.cisco.com/en-us/Adapters/Linksys-AE1000-Wirelessn-connector_stcVVproductId97826164VVcatId551966VVviewprod.htm

Given that KDE doesn't seem to have the network management
comprehensiveness that current GNOME network-manager attempts, & that
the KDE website doesn't seem to have a Network management sw topic, nor
wifi, oriented mailing lists, & that lacking those infrastructures, the
KUbuntu users list is not highly likely to have users highly
knowledgeable about specific wifi client hw & what sw to use to manage
it, 
- where are some better info sources (website, mailing list) for how one
would best manage wifi networking with eht AE1000 device under KUbuntu
10.4?


Motivating factor: attempting to use the KUbuntu GNU(Linux) system where
there is a wifi network that a windows computer using Intel wifi HW is
showing a 150Mb/s wifi connection, & observed Cisco wifi AP.


==  KDE wifi info not findable in a reasonable search time, &/or 5 years
out of date:
http://kde.org/applications/internet/kwlan/
Kwlan is an alternative network manager supporting profiles for dial-up,
wired and wireless networks.
(Deprecated by NetworkManager)

"NetworkManager" isn't show under KDE Applications: System, Internet nor
Utilities.

http://kde.org/applications/
http://kde.org/applications/internet/
http://kde.org/applications/system/
http://kde.org/applications/utilities/

http://techbase.kde.org/Development/Tutorials/Solid_Network_Tutorial

Network Configuration
This manual explains how to install and use KNetworkConf,
Revision 1.0 (2005-03-24)
http://docs.kde.org/development/en/kdeadmin/kcontrol/knetworkconf/index.html


==
Is the linux-wireless@vger.kernel.org list the only list where more
knowledgeable info on this topic would be obtained?

==
Is using this under KUbuntu going to require an effort like this:
"get his new Linksys AE1000  working on Fedora 12
2.6.31.9-174.fc12.x86_64, so I thought I'd post my findings, since they
were fairly scarce, and less than straight forward."
http://forums.fedoraforum.org/showthread.php?t=244215


Thanks. :)


=====  References:

1) Great Device

    white Reviewed By: Jeff on 5/9/2010
    Rating + 4 
    Tech Level Tech Level: high - Ownership: 1 day to 1 week

    Pros: * Great speeds.
    * Great cable length.
    * Runs cool.
    Cons: * No official Linux support.
    * Somewhat over priced.
    Other Thoughts: It lost a star because its a Windows only device and
    the price.

    I am using this to stream HD content off a RAID server and I am
    quite pleased. I am seeing speeds between 7-9 MB/s. I should point
    out that I am using this with Linux despite no official support. I
    have tried this device on Windows as well and received similar
    results. If you want to run this on Linux, you'll want to look into
    Ralink's RT3572USB driver.

http://www.newegg.com/Product/Product.aspx?Item=N82E16833124389

http://www.ralinktech.com/support.php?s=2


2) Title: Cisco/Linksys AE1000. Anyway to get this to work with
aircrack?
Quote from: 400 on July 24, 2010, 04:44:27 am
Someone here managed to get it working on Fedora
http://forums.fedoraforum.org/showthread.php?t=244215
it might get you going...

http://www.ralinktech.com/support.php?s=2


3)  http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/

4)  http://www.linuxwireless.org/en/users/Support
Linux wireless mailing list
You can send question to the Linux wireless mailing list, however, you
are highly encouraged to first check on the IRC channel above. 

http://www.linuxwireless.org/en/developers/MailingLists

==  Join in the Global weekly meetings, via VOIP, about all Free SW HW & Culture
http://sites.google.com/site/berkeleytip/

