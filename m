Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44519 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbZH0CW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 22:22:27 -0400
Received: by bwz19 with SMTP id 19so619570bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 19:22:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A95D2A8.9090208@lwfinger.net>
References: <1251323178-7173-1-git-send-email-netrolller.3d@gmail.com>
	<4A95D2A8.9090208@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 27 Aug 2009 04:22:08 +0200
Message-ID: <69e28c910908261922p5ee551aeobd535fc2ceb2a814@mail.gmail.com>
Subject: Re: Congratulations
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/27 Larry Finger <Larry.Finger@lwfinger.net>:
> Gábor,
>
> Congratulations on your progress. With today's patches my BCM4312
> 802.11b/g card with PCI ID 14e4:4315 works - I'm using it at the
> moment. I'm using WPA2 encryption and have connected to APs on
> channels 1 and 11. My logs are clean.

That's good to hear!

>
> As you noted, performance is a little weak, but I get transmits of
> 9-11 Mb/s and receive rates up to 18 Mb/s - eminently usable.

What is your actual RX throughput? For me, it's usable up to 24Mb/s,
but the actual throughput is limited to 1.2Mb/s.

>
> I certainly hope that you get the patches approved so that these
> changes will be in the 2.6.32 kernel.

The patches are already in the tree, actually.

>
> Once again, congratulations to you, Michael, and the others members of
> the reverse engineering team. Seeing the device comes to life makes
> all those hours of staring at MIPS binary code seem very worthwhile.
>
> For those of you with N PHYs, the RE of those devices will be my next
> step.

My next step will be calibration. :-)

(However, calibration specs are still not complete - there are 2 wlc_*
calls in PR41573. But that only matters for rev.0, and apparently all
4312s are rev.1.)

>
> Larry
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
