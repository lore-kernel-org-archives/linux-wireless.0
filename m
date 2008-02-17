Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:60819 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbYBQKNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 05:13:18 -0500
Received: from localhost (23.249.105.73) by aa012msr.fastwebnet.it (8.0.013.5)
        id 47AAE88C0174BF55 for linux-wireless@vger.kernel.org; Sun, 17 Feb 2008 11:13:02 +0100
Date: Sun, 17 Feb 2008 11:12:00 +0100
From: Fabio Venturi <f.venturi@tdnet.it>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem compiling ath5k
Message-ID: <20080217101159.GA7234@silverstar> (sfid-20080217_101410_020712_44D8DA82)
References: <20080216103846.GC9290@silverstar> <1c252d490802160400gd8a11a6y7e164d9b05f626c8@mail.gmail.com> <20080216172923.GA7439@silverstar> <1c252d490802161607t2bfa8545m1d48b17b272d2534@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1c252d490802161607t2bfa8545m1d48b17b272d2534@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 17, 2008 at 01:07:25AM +0100, Joachim Frieben wrote:
> 2008/2/16, Fabio Venturi <f.venturi@tdnet.it>:
> >
> > On Sat, Feb 16, 2008 at 01:00:39PM +0100, Joachim Frieben wrote:
> > OK,
> > now the driver compile and load without any problem and
> > the wlan0 and master0 devices are created.
> > There are no error in dmesg, but I can't scan for stations,
> > iwlist wlan0 scan
> > says there are no active stations.
> > Do I need extra modules for scanning?
> > I'm using an Atheros AR2413, is this device supposed to work with
> > the ath5k module?
> 
> 
> That's exactly the situation that I do encounter myself because I'm using
> the same chipset. I have tried a preview snapshot of the ath5k driver which
> is not public yet, and for that one scanning works! 

Where can I get that preview snapshot of ath5k? 
I could test it.

> However, data
> transmission doesn't work yet. The main developer is about to resume work on
> the driver after a break since late December, and he has some pending stuff
> which needs to be merged with the development tree. Stay tuned, this should
> be a matters of days. Any significant update will be announced on the
> wireless list anyway. There are many people out there eagerly waiting for
> this to happen ...
> 
> Cheers,
> 
> JF

I'll stay tuned as you suggest.
Best regards,
Fabio




> Luis R. Rodriguez wrote:
>
> You need to turn your interface up first:

> ip link set wlan0 up

> Or

> ifconfig wlan0 up

>   Luis

The interface is up and running, but somehow it seems missing
the beacon packets.
Best regards,
Fabio
