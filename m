Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.pc-advies.be ([83.149.101.17]:36137 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755059Ab2LLVh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:37:59 -0500
Date: Wed, 12 Dec 2012 22:37:53 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	linux-mips@linux-mips.org
Subject: Re: [PATCH v2 00/15] watchdog/bcm47xx/bcma/ssb: add support for SoCs with PMU
Message-ID: <20121212213753.GC31853@spo001.leaseweb.com> (sfid-20121212_223803_219062_2E2BC448)
References: <1353975925-32056-1-git-send-email-hauke@hauke-m.de> <CACna6rwmfpNFAFZpvbt8GHzofC6UoyBC4oKF5rL=9xN5_=gYXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACna6rwmfpNFAFZpvbt8GHzofC6UoyBC4oKF5rL=9xN5_=gYXw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > @Wim Could you give me an ACK on the "watchdog: bcm47xx_wdt.c:" patches
> >      so that John could take them trough the wireless-testing tree, or
> >      provide me with some feedback on what I should change.
> 
> Hi Wim,
> 
> Have you got a chance to look at that patches?
> 
> I've some additional bcma changes I wish to submit on top of this :)

Sorry, but family health issues have distracted me from kernel stuff the last months.
Things are better now.

Concerning these patches: The correct decision has been taken to split this allready up
into the bcma/ssb patches and do the watchdog patches later on. I will check the watchdog
part and react on it as soon as possible.

Kind regards,
Wim.

