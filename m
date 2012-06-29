Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59215 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2F2Vn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 17:43:59 -0400
Date: Fri, 29 Jun 2012 09:37:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, b43-dev@lists.infradead.org,
	arend@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] bcma misc updates
Message-ID: <20120629133758.GA30528@tuxdriver.com> (sfid-20120629_234417_476406_03ECBD25)
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
 <CACna6rxL8xya8eOfBUvT43y0ZhHWKJyEef1G2pe5THi4DfOmkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rxL8xya8eOfBUvT43y0ZhHWKJyEef1G2pe5THi4DfOmkQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 29, 2012 at 09:44:29AM +0200, Rafał Miłecki wrote:
> 2012/6/5 Hauke Mehrtens <hauke@hauke-m.de>:
> > These are some updates for bcma. Some are extending or completing some
> > workarounds for PCIe based wireless cards. A patch adds
> > bcma_pmu_spuravoid_pllupdate, used by brcmsmac and an other patch adds
> > constants for the chip ids. This code is mostly based on code from
> > brcmsmac and the Broadcom SDK for BCM47XX SoCs.
> >
> > This was tested on a BCM4718 SoC with a BCM43224 PCIe and a BCM5357.
> > The Wifi part of the BCM4718 and BCM43224 is more or less working with
> > brcmsmac, which need some more patches for that, but it has low speed
> > and some times or with some access points I still get errors. The wifi
> > of the BCM5357 does not work.
> >
> > Hauke Mehrtens (8):
> >  bcma: extend workaround for bcm4331
> >  bcma: add constants for chip ids
> >  bcma: Fix for 4329b0 bad LPOM is detection
> >  bcma: add PCI ID for BCM43224
> >  bcma: complete workaround for BCMA43224 and BCM4313
> >  bcma: handle SoCs in pmu initialization
> >  bcma: add bcma_pmu_spuravoid_pllupdate()
> >  bcma: add mdelay bcma_pmu_resources_init()
> 
> John: can you take the following patches from this patchset?
> 1/8
> 2/8
> 4/8
> 5/8
> 7/8
> 
> Following patches should be dropped:
> 3/8 - BCM4329 fix should be dropped, not improved
> 6/8 - functions touched by patch should be dropper, not improved
> 8/8 - patch is fine, but doesn't apply cleanly

I seem to have dropped the series some time ago.  Perhaps Hauke could
repost the appropriate collection?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
