Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:48512 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZBEXBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 18:01:13 -0500
Message-ID: <38242.82.152.255.229.1233874870.squirrel@www.phantomjinx.co.uk> (sfid-20090206_000118_065237_C8BC55CD)
In-Reply-To: <498B5C63.7060602@lwfinger.net>
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
    <53749.82.152.255.229.1233865126.squirrel@www.phantomjinx.co.uk>
    <498B5C63.7060602@lwfinger.net>
Date: Thu, 5 Feb 2009 23:01:10 -0000 (UTC)
Subject: Re: rtl8187 sleeping/hanging
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

Thanks for the response. I am coming to the conclusion that it is the
transmission strength of the wireless. However, I am no expert in this.

Have put the old router downstairs and maintained a connection for the
rest of the evening. Clearly it would appear that the laptop is not
picking up the router's signal as effectively as my old laptop. Only
conclusion since both laptops in the same location and 2 different rout=
ers
tried.

The 20db reported in iwconfig by mac80211 is not the actual data, is th=
e
signal strength please? I can see the signal strength change upon repea=
ted
calls to iwconfig and downstairs even when seemingly "out of range" and
failing to ping anything, it still reports a signal strength of above 5=
0%.

Since there is nothing to fix per se with the driver, is there anything
further to interrogate to eek out any info on what is going on when the
network seemingly drops?

Cheers for your help.

PGR

> P.G. Richardson wrote:
>> Sadly, it seems my new laptop is not so reliable...
>> - Moving around when constantly pinging causes the pinging to halt,
>> missing packets.
>> - If I dont use the network connection for a few minutes (think it t=
ends
>> to be when on battery but not definitely tested), it seems the wlan0
>> dies
>> / goes to sleep / hangs. Not sure which. Sometimes it comes back wit=
h a
>> quick ping to the router. Other occasions I have to re-modprobe the
>> driver.
>
> On my RTL8187, this does not happen.
>
>> I thought it might be the hardware is not as powerful as my old lapt=
op
>> but
>> iwconfig reports both have a 20db tx value so figured they are
>> connecting
>> with the same transmit power.
>
> That number comes from mac80211 and is set by the regulatory data
> base. It has no relation to the actual power being transmitted!!!
>
>> Wondered if it might be to do with cpu frequency scaling as the defa=
ult
>> kde4 powersave settings have the following settings:
>> - AC adapter: cpu freq scaling =3D performance
>> - Battery: cpu freq scaling =3D dynamic (less aggressive)
>> (Changed Battery to performance to see if this makes any difference)
>
> Shouldn't affect the results.
>
> One thing you might do is get the vendor driver for the RTL8187L from
> the Realtek site, compile it (good luck), and try it. There may be
> differences between their version and the in-kernel driver. Some
> 8187's work great (mine is one of them), and others do not.
> Unfortunately, there is nothing to fix for my stick.
>
> Larry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


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
