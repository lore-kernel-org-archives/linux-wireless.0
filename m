Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34347 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2F3JTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 05:19:53 -0400
Received: by wgbds11 with SMTP id ds11so1483060wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jun 2012 02:19:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Date: Sat, 30 Jun 2012 11:19:51 +0200
Message-ID: <CACna6rwmGOBULax1UZPjhNnHW63bfCOcgWCmoOscyrcbeFGzig@mail.gmail.com> (sfid-20120630_112035_706622_FF16F96E)
Subject: Re: [PATCH v2 0/9] bcma misc updates
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, b43-dev@lists.infradead.org,
	arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/30 Hauke Mehrtens <hauke@hauke-m.de>:
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
> These patches are based on current wireless-testing.

Look fine for me. I'll need to rebase my logging patch...

-- 
Rafał
