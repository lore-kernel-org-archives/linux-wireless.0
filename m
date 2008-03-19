Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mamut.efuzja.net.pl ([193.93.204.8]:56159 "EHLO efuzja.net.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936708AbYCSVjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 17:39:14 -0400
From: Kamil =?utf-8?q?Seroczy=C5=84ski?= <serkamil@serkamil.org.pl>
To: mb@bu3sch.de, stefano.brivio@polimi.it
Subject: b43 and latest compat-wireless ( 2.8-48-g7a95475 ) - don't work
Date: Wed, 19 Mar 2008 22:08:01 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200803192208.01318.serkamil@serkamil.org.pl> (sfid-20080319_213947_072441_D4C8F629)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

i have problem with compat-wireless ... i try tell you what hapend, and=
 i hope=20
you ( meybe we ;) ) find problem and fix them ...

I have hp compaq 6715b ( GC049ES; links, if you want to know some more =
on the=20
bottom the mail ) witch broadcom 4311 rev. 2 ( Network controller: Broa=
dcom=20
Corporation BCM94311MCG wlan mini-PCI (rev 02); 14e4:4311 (rev 02) ) wi=
tch=20
linux kernel 2.6.22-2 ( # uname -a Linux serkamil 2.6.22-2-amd64 #1 SMP=
 Thu=20
Aug 30 23:43:59 UTC 2007 x86_64 GNU/Linux ).

This device work fine witch compat-wireless-2.6 where in the file=20
compat-release is string '2.8-12-g0270147'.
The same device, on the same OS and Kernel don't working witch latest=20
comat-wireless-2.6 where in the file compat-release is=20
string '2.8-48-g7a95475'.

1. where i can find what changeing? I thing in=20
http://git.kernel.org/?p=3Dlinux/kernel/git/mcgrof/compat-wireless-2.6.=
git;a=3Dtree;hb=3DHEAD=20
but i don't know how to find it there.
2. it is important ( helping ) information for developers?
3. how i can help developers makeing working/good software/driver? what=
 i can=20
do? if you want something, tell me, and i try help you.

[links]

HP Compaq 6715b and 6715s Notebook PC and HP Compaq 6710b and 6710s Not=
ebook=20
PC Maintenance and Service Guide:=20
http://h20000.www2.hp.com/bc/docs/support/SupportManual/c01039189/c0103=
9189.pdf

QuickSpecs HP Compaq 6715b Notebook PC:=20
http://h18000.www1.hp.com/products/quickspecs/12686_na/12686_na.PDF

best wishes and greetings
and <b>realy big thanks</b> for your working, with makeing driver for l=
inux

sorry for my english ... it ( my english ) is terrible !!
--=20
Kamil Seroczy=C5=84ski
e-mail: serkamil(at)serkamil(dot)org(dot)pl
skype:  serkamil
sip:	serkamil(at)ekiga(dot)net
jabber: serkamil(at)jabber(dot)org
gadu:   3002410
yahoo:  serkamil
aim:    serkamil
icq:	381905938
tlen:	serkamil
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
