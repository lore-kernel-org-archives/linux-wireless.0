Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:59897 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbYBPRai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2008 12:30:38 -0500
Received: from localhost (23.249.105.73) by aa012msr.fastwebnet.it (8.0.013.5)
        id 47AAE88C015F4106 for linux-wireless@vger.kernel.org; Sat, 16 Feb 2008 18:30:24 +0100
Date: Sat, 16 Feb 2008 18:29:23 +0100
From: Fabio Venturi <f.venturi@tdnet.it>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem compiling ath5k
Message-ID: <20080216172923.GA7439@silverstar> (sfid-20080216_173041_578414_ACCA8B2A)
References: <20080216103846.GC9290@silverstar> <1c252d490802160400gd8a11a6y7e164d9b05f626c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1c252d490802160400gd8a11a6y7e164d9b05f626c8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 16, 2008 at 01:00:39PM +0100, Joachim Frieben wrote:
> > Hello to the list,
> > I'd like to try the ath5k kernel module for my Atheros AR2413 Wireless
> > Card
> > so I downloaded the compat-wireless-2.6.tar.bz2
> > I'm running a 2.6.24.2 kernel (the laste stable),
> > but the compile stage ends immediately:
> I simply removed ipw2100 from config.mk (I think that was the name ..) in
> order to skip the build of ipw2100.ko which is ok since I was just
> interested in the ath5k driver. All other drivers built correctly then.

OK,
now the driver compile and load without any problem and
the wlan0 and master0 devices are created.
There are no error in dmesg, but I can't scan for stations,
iwlist wlan0 scan
says there are no active stations.
Do I need extra modules for scanning?
I'm using an Atheros AR2413, is this device supposed to work with
the ath5k module?
Thank you in advance for any help,
regards,
Fabio
