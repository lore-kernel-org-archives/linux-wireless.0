Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:45996 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754977AbZBFRsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 12:48:07 -0500
Message-ID: <498C77C6.3060608@lwfinger.net> (sfid-20090206_184813_026518_56CCA53E)
Date: Fri, 06 Feb 2009 11:47:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 sleeping/hanging
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>    <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>    <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>    <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>    <49871083.5040309@lwfinger.net>    <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk>    <3ace41890902021548o39b5f02veacc0bd650e92c7@mail.gmail.com>    <20090203142807.GC10968@tuxdriver.com>    <44120.62.172.74.16.1233679156.squirrel@www.phantomjinx.co.uk>    <49887936.3010203@lwfinger.net>    <53749.82.152.255.229.1233865126.squirrel@www.phantomjinx.co.uk>    <498B5C63.7060602@lwfinger.net> <38242.82.152.255.229.1233874870.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <38242.82.152.255.229.1233874870.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:

> The 20db reported in iwconfig by mac80211 is not the actual data, is the
> signal strength please? I can see the signal strength change upon repeated
> calls to iwconfig and downstairs even when seemingly "out of range" and
> failing to ping anything, it still reports a signal strength of above 50%.

Signal strength may have even less physical meaning that the power.
Some devices, such as those by Broadcom, report the received signal
strength with some accuracy. The RTL8187B is supposed to have such an
output; however, my testing showed it to be essentially random. The
only reported quantity that could be used was the automatic gain
control setting of the receiver. This was calibrated against the
BCM4311 at two points, assumed to be linear, and the signal strength
and signal quality numbers were derived. For the RTL8187, a similar
scheme was used. As you can tell, only relative values for these
quantities are meaningful. The fact that your signal strength is above
50% means very little.

Larry
