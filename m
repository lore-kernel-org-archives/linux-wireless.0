Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.pc-advies.be ([83.149.101.17]:42123 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757764Ab3AIMpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 07:45:43 -0500
Date: Wed, 9 Jan 2013 13:45:36 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	linux-mips@linux-mips.org
Subject: Re: [PATCH v3 00/11] watchdog/bcm47xx/bcma/ssb: add support for SoCs with PMU
Message-ID: <20130109124536.GG10667@spo001.leaseweb.com> (sfid-20130109_134546_181755_E87A7C72)
References: <1354729568-19993-1-git-send-email-hauke@hauke-m.de> <CACna6rzcYReMs1ZxKuMDjAte+3bX_rjvd3Jd7265tgkMF2E-oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzcYReMs1ZxKuMDjAte+3bX_rjvd3Jd7265tgkMF2E-oA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafal,

this will probably be done after I reviewed the v2 watchdog part first.

Kind regards,
Wim.

> 2012/12/5 Hauke Mehrtens <hauke@hauke-m.de>:
> > This patch series improves the functions for setting the watchdog
> > driver in ssb amd bcma. It also makes ssb and bcma register a platform
> > device which could be used by a watchdog driver to better set the times
> > where the system should restart. The patches for the watchdog driver
> > will be send later and were removed in v3.
> >
> > This code is currently based on the wireless-testing/master tree by
> > John Linville.
> >
> > v3:
> >  * Remove changes done to the watchdog driver so John could pull this
> >    into wireless-testing, this sill works with the old watchdog driver.
> >    The patches changing the watchdog driver will be send later.
> >    This was done to get this into 3.8 because Wim Van Sebroeck is
> >    neither giving an Ack or a Nack on these patches and we want to do
> >    more changes to bcma/ssb on top of these.
> 
> Your changes are already in Linus's tree, do you plan to re-send
> watchdog patches dropped in V3 through linux-watchdog? Can you take
> care of this?
> 
> -- 
> Rafał
