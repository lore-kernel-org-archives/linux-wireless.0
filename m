Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52703 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab3AIJYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 04:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
References: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
Date: Wed, 9 Jan 2013 10:24:36 +0100
Message-ID: <CACna6rzcYReMs1ZxKuMDjAte+3bX_rjvd3Jd7265tgkMF2E-oA@mail.gmail.com> (sfid-20130109_102444_742229_8110CCE0)
Subject: Re: [PATCH v3 00/11] watchdog/bcm47xx/bcma/ssb: add support for SoCs
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

2012/12/5 Hauke Mehrtens <hauke@hauke-m.de>:
> This patch series improves the functions for setting the watchdog
> driver in ssb amd bcma. It also makes ssb and bcma register a platform
> device which could be used by a watchdog driver to better set the times
> where the system should restart. The patches for the watchdog driver
> will be send later and were removed in v3.
>
> This code is currently based on the wireless-testing/master tree by
> John Linville.
>
> v3:
>  * Remove changes done to the watchdog driver so John could pull this
>    into wireless-testing, this sill works with the old watchdog driver.
>    The patches changing the watchdog driver will be send later.
>    This was done to get this into 3.8 because Wim Van Sebroeck is
>    neither giving an Ack or a Nack on these patches and we want to do
>    more changes to bcma/ssb on top of these.

Your changes are already in Linus's tree, do you plan to re-send
watchdog patches dropped in V3 through linux-watchdog? Can you take
care of this?

-- 
Rafał
