Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43299 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2F2Hoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 03:44:30 -0400
Received: by eaak11 with SMTP id k11so1242644eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2012 00:44:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
Date: Fri, 29 Jun 2012 09:44:29 +0200
Message-ID: <CACna6rxL8xya8eOfBUvT43y0ZhHWKJyEef1G2pe5THi4DfOmkQ@mail.gmail.com> (sfid-20120629_094434_245642_357C9BA1)
Subject: Re: [PATCH 0/8] bcma misc updates
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linville@tuxdriver.com, Hauke Mehrtens <hauke@hauke-m.de>
Cc: b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/5 Hauke Mehrtens <hauke@hauke-m.de>:
> These are some updates for bcma. Some are extending or completing some
> workarounds for PCIe based wireless cards. A patch adds
> bcma_pmu_spuravoid_pllupdate, used by brcmsmac and an other patch adds
> constants for the chip ids. This code is mostly based on code from
> brcmsmac and the Broadcom SDK for BCM47XX SoCs.
>
> This was tested on a BCM4718 SoC with a BCM43224 PCIe and a BCM5357.
> The Wifi part of the BCM4718 and BCM43224 is more or less working with
> brcmsmac, which need some more patches for that, but it has low speed
> and some times or with some access points I still get errors. The wifi
> of the BCM5357 does not work.
>
> Hauke Mehrtens (8):
>  bcma: extend workaround for bcm4331
>  bcma: add constants for chip ids
>  bcma: Fix for 4329b0 bad LPOM is detection
>  bcma: add PCI ID for BCM43224
>  bcma: complete workaround for BCMA43224 and BCM4313
>  bcma: handle SoCs in pmu initialization
>  bcma: add bcma_pmu_spuravoid_pllupdate()
>  bcma: add mdelay bcma_pmu_resources_init()

John: can you take the following patches from this patchset?
1/8
2/8
4/8
5/8
7/8

Following patches should be dropped:
3/8 - BCM4329 fix should be dropped, not improved
6/8 - functions touched by patch should be dropper, not improved
8/8 - patch is fine, but doesn't apply cleanly

-- 
Rafał
