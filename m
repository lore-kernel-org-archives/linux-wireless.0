Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:54695 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbZBFS42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:28 -0500
Message-ID: <58412.82.152.255.229.1233946585.squirrel@www.phantomjinx.co.uk> (sfid-20090206_195634_905110_3692AECF)
In-Reply-To: <498C77C6.3060608@lwfinger.net>
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
    <38242.82.152.255.229.1233874870.squirrel@www.phantomjinx.co.uk>
    <498C77C6.3060608@lwfinger.net>
Date: Fri, 6 Feb 2009 18:56:25 -0000 (UTC)
Subject: Re: rtl8187 sleeping/hanging
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> P.G. Richardson wrote:
>
>> The 20db reported in iwconfig by mac80211 is not the actual data, is=
 the
>> signal strength please? I can see the signal strength change upon
>> repeated
>> calls to iwconfig and downstairs even when seemingly "out of range" =
and
>> failing to ping anything, it still reports a signal strength of abov=
e
>> 50%.
>
> Signal strength may have even less physical meaning that the power.
> Some devices, such as those by Broadcom, report the received signal
> strength with some accuracy. The RTL8187B is supposed to have such an
> output; however, my testing showed it to be essentially random. The
> only reported quantity that could be used was the automatic gain
> control setting of the receiver. This was calibrated against the
> BCM4311 at two points, assumed to be linear, and the signal strength
> and signal quality numbers were derived. For the RTL8187, a similar
> scheme was used. As you can tell, only relative values for these
> quantities are meaningful. The fact that your signal strength is abov=
e
> 50% means very little.

Good to know.

With a repeater in the living room now, I have 100/100 signal strength =
and
fewer problems with connectivity. Not perfect I think due to the positi=
on
of the router. Still network connectivity improving.

Thanks for the info.

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
