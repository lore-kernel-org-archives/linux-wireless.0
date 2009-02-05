Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53474 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbZBEVi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 16:38:57 -0500
Message-ID: <498B5C63.7060602@lwfinger.net> (sfid-20090205_223900_124122_C7EDD2FD)
Date: Thu, 05 Feb 2009 15:38:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 sleeping/hanging
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>    <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>    <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>    <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>    <49871083.5040309@lwfinger.net>    <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk>    <3ace41890902021548o39b5f02veacc0bd650e92c7@mail.gmail.com>    <20090203142807.GC10968@tuxdriver.com>    <44120.62.172.74.16.1233679156.squirrel@www.phantomjinx.co.uk>    <49887936.3010203@lwfinger.net> <53749.82.152.255.229.1233865126.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <53749.82.152.255.229.1233865126.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:
> Sadly, it seems my new laptop is not so reliable...
> - Moving around when constantly pinging causes the pinging to halt,
> missing packets.
> - If I dont use the network connection for a few minutes (think it tends
> to be when on battery but not definitely tested), it seems the wlan0 dies
> / goes to sleep / hangs. Not sure which. Sometimes it comes back with a
> quick ping to the router. Other occasions I have to re-modprobe the
> driver.

On my RTL8187, this does not happen.

> I thought it might be the hardware is not as powerful as my old laptop but
> iwconfig reports both have a 20db tx value so figured they are connecting
> with the same transmit power.

That number comes from mac80211 and is set by the regulatory data
base. It has no relation to the actual power being transmitted!!!

> Wondered if it might be to do with cpu frequency scaling as the default
> kde4 powersave settings have the following settings:
> - AC adapter: cpu freq scaling = performance
> - Battery: cpu freq scaling = dynamic (less aggressive)
> (Changed Battery to performance to see if this makes any difference)

Shouldn't affect the results.

One thing you might do is get the vendor driver for the RTL8187L from
the Realtek site, compile it (good luck), and try it. There may be
differences between their version and the in-kernel driver. Some
8187's work great (mine is one of them), and others do not.
Unfortunately, there is nothing to fix for my stick.

Larry

