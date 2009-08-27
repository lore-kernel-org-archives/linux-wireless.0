Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:54907 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZH0C5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 22:57:09 -0400
Received: by pzk30 with SMTP id 30so774767pzk.4
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 19:57:11 -0700 (PDT)
Message-ID: <4A95F5B5.2020007@lwfinger.net>
Date: Wed, 26 Aug 2009 21:55:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Congratulations
References: <1251323178-7173-1-git-send-email-netrolller.3d@gmail.com> 	<4A95D2A8.9090208@lwfinger.net> <69e28c910908261922p5ee551aeobd535fc2ceb2a814@mail.gmail.com>
In-Reply-To: <69e28c910908261922p5ee551aeobd535fc2ceb2a814@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 2009/8/27 Larry Finger <Larry.Finger@lwfinger.net>:
>> Gábor,
>>
>> Congratulations on your progress. With today's patches my BCM4312
>> 802.11b/g card with PCI ID 14e4:4315 works - I'm using it at the
>> moment. I'm using WPA2 encryption and have connected to APs on
>> channels 1 and 11. My logs are clean.
> 
> That's good to hear!
> 
>> As you noted, performance is a little weak, but I get transmits of
>> 9-11 Mb/s and receive rates up to 18 Mb/s - eminently usable.
> 
> What is your actual RX throughput? For me, it's usable up to 24Mb/s,
> but the actual throughput is limited to 1.2Mb/s.

That 18 Mb/s receive rate was observed data transfer from my server
that is wired to the router/AP and over the air to the BCM4312, just
as the 11 Mb/s was observed transfer from the BCM4312 to the server. I
have no idea what bit rate was set into the interface. Every time I
looked, it was at 1 Mb/s, but the throughput is better than that.

--snip--

>> For those of you with N PHYs, the RE of those devices will be my next
>> step.
> 
> My next step will be calibration. :-)
> 
> (However, calibration specs are still not complete - there are 2 wlc_*
> calls in PR41573. But that only matters for rev.0, and apparently all
> 4312s are rev.1.)

I missed those (obviously). Are there any other places in the LP PHY
that need work?

Larry

