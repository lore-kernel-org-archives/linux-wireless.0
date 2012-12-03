Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43706 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LCIp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 03:45:28 -0500
MIME-Version: 1.0
In-Reply-To: <1353975925-32056-1-git-send-email-hauke@hauke-m.de>
References: <1353975925-32056-1-git-send-email-hauke@hauke-m.de>
Date: Mon, 3 Dec 2012 09:45:26 +0100
Message-ID: <CACna6rwmfpNFAFZpvbt8GHzofC6UoyBC4oKF5rL=9xN5_=gYXw@mail.gmail.com> (sfid-20121203_094533_190926_4C087D35)
Subject: Re: [PATCH v2 00/15] watchdog/bcm47xx/bcma/ssb: add support for SoCs
 with PMU
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, wim@iguana.be,
	linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/11/27 Hauke Mehrtens <hauke@hauke-m.de>:
> This patch series improves the watchdog driver used on the Broadcom
> bcm47xx SoCs.
> The watchdog driver does not access the functions directly any more,
> but it registers as a platform device driver and ssb and bcma are
> registering a device for this watchdog driver.
> This also adds support for SoCs with a power management unit (PMU),
> which have different clock rates.
>
> This code is currently based on the wireless-testing/master tree by
> John Linville, because there are some changes in ssb and bcma in that
> tree queued for 3.8 which will conflict with these changes, if this
> would be based on an other tree. I have no problem with rebasing this
> onto any other tree.
>
> @Wim Could you give me an ACK on the "watchdog: bcm47xx_wdt.c:" patches
>      so that John could take them trough the wireless-testing tree, or
>      provide me with some feedback on what I should change.

Hi Wim,

Have you got a chance to look at that patches?

I've some additional bcma changes I wish to submit on top of this :)

-- 
Rafał
