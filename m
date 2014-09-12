Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:52281 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaILHsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 03:48:13 -0400
From: Bernhard Schiffner <bernhard@schiffner-limbach.de>
To: andrea.merello@gmail.com
Cc: ralf@czekalla.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Rtl8187se regression [was: rtl8187se - serious regressions since merge out of staging into 818x]
Date: Fri, 12 Sep 2014 09:47:38 +0200
Message-ID: <1472277.xX1dghvxoC@bs8> (sfid-20140912_094816_953072_D6D83A5E)
In-Reply-To: <CAN8YU5NOApnft04+N3rSQF3j9d9N47-A6m4n-1-2KNHq+1EYKA@mail.gmail.com>
References: <CAN8YU5NOApnft04+N3rSQF3j9d9N47-A6m4n-1-2KNHq+1EYKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Anrea, Larry,

I used the new driver (still without the latest patches) only in hotels slow 
DSL/Wireless environment and there I noted no regression.

Because of the problems I'am going now to a special site, where I have a local 
networks (LAN/WLAN), good internet connection and root access to Linux 
machines.
This should be a good thing to do real testing.

1.) Andrea, can you resend me the latest patches (perhaps against 3.16) 
please?
(only to confirm that we are in "synchronous" mode.)

2.) Andrea, Larry, John are you interested to have root access to my laptop 
using the rtl8187se?
(Perhaps it can stay there over the weekend too.)

3.) My test for maximal troughput is to run a connection /dev/zero -> nc ->|-> 
nc -> /dev/null.
Any other ideas?

4.) I think to have this setup ready about 11:30 UTC.

I'am open to any suggestion from your side.


Bernhard

Am Freitag, 12. September 2014, 02:18:03 schrieb Andrea Merello:
> My aplogies for this quick and a bit messy reply: I m from mobile.
> 
> @Xose
> Thank you for forwarding me that. I wasn t aware of it.
> 
> (BTW a couple of other people reported a similar issue)
> 
> @Ralf
> The driver still have some not implemented features, including signal
> strenght measure, furthermore some fixes that might improve performances
> should be on the way for 3.17.
> 
> @Larry, Bernhard
> I think those fixes was basically the same of some RFT patch I sent you
> some time ago..
> Have you had any occasion to test those patches?
> 
> @Ralf, all..
> I must say that I never been able to reproduce any severe performance
> regression here, for this reason I'm asking people who reports this to make
> some testing for me if possible..
> 
> Here you can find  a similar report and my answer where I asked for the
> tests:
> https://bugzilla.kernel.org/show_bug.cgi?id=83631
> 
> If you could do some of those test for me, that would be great.
> 

