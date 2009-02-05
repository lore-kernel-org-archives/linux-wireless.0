Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:37607 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759793AbZBEUSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 15:18:47 -0500
Received: from localhost ([127.0.0.1] helo=www.phantomjinx.co.uk)
	by vilya.visn.co.uk with esmtpa (Exim 4.69)
	(envelope-from <p.g.richardson@phantomjinx.co.uk>)
	id 1LVAgP-0003OX-VG
	for linux-wireless@vger.kernel.org; Thu, 05 Feb 2009 20:18:46 +0000
Message-ID: <53749.82.152.255.229.1233865126.squirrel@www.phantomjinx.co.uk> (sfid-20090205_211906_558435_32D9222A)
In-Reply-To: <49887936.3010203@lwfinger.net>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>
    <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>
    <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>
    <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>
    <49871083.5040309@lwfinger.net>
    <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk>
    <3ace41890902021548o39b5f02veacc0bd650e92c7@mail.gmail.com>
    <20090203142807.GC10968@tuxdriver.com>
    <44120.62.172.74.16.1233679156.squirrel@www.phantomjinx.co.uk>
    <49887936.3010203@lwfinger.net>
Date: Thu, 5 Feb 2009 20:18:46 -0000 (UTC)
Subject: rtl8187 sleeping/hanging
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

Installed current snapshot -> compat-wireless-2009-02-05

Still trying to get to grips with the rtl8187 driver. Not sure at the
moment whether my current problems are the fault of the laptop hardware=
 or
the driver. Maybe someone who has a similar wireless chip would care to
compare notes.

My router is situated upstairs. I have, this week, changed it to a new =
one
with a 5db gain level antenna rather than the original that had a 2db.

I have no problems with my old laptop using the ipw2200 driver connecti=
ng
to either of my routers. I can walk anywhere in the house with doors sh=
ut
and still get a solid ping.

Sadly, it seems my new laptop is not so reliable...
- Moving around when constantly pinging causes the pinging to halt,
missing packets.
- If I dont use the network connection for a few minutes (think it tend=
s
to be when on battery but not definitely tested), it seems the wlan0 di=
es
/ goes to sleep / hangs. Not sure which. Sometimes it comes back with a
quick ping to the router. Other occasions I have to re-modprobe the
driver.

I thought it might be the hardware is not as powerful as my old laptop =
but
iwconfig reports both have a 20db tx value so figured they are connecti=
ng
with the same transmit power.

Wondered if it might be to do with cpu frequency scaling as the default
kde4 powersave settings have the following settings:
- AC adapter: cpu freq scaling =3D performance
- Battery: cpu freq scaling =3D dynamic (less aggressive)
(Changed Battery to performance to see if this makes any difference)

Either way if people have any ideas they could throw at me then I would=
 be
much appreciated as doing anything networky such as a quick google is
turning into a full blown network marathon!

Distro: Mandriva 2009
Kernel: 2.6.27.10-desktop586-1mnb
IP Address: static
Network: handled by ifcfg script
Wireless: WPA2-PSK using TKIP
Channel: Tried both 11 and 8 and has no affect

Happy to provide any more info as required.

Regards

PGR

--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
