Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64449 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2F2KGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 06:06:43 -0400
Received: by werb14 with SMTP id b14so893488wer.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2012 03:06:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340964011-17528-1-git-send-email-zajec5@gmail.com>
References: <1340964011-17528-1-git-send-email-zajec5@gmail.com>
Date: Fri, 29 Jun 2012 12:06:42 +0200
Message-ID: <CACna6rxTYbSLu8KFOWSkK38Ft3DxJ2GZqC_s-SCRBpw35Ui48A@mail.gmail.com> (sfid-20120629_120647_205571_E440606F)
Subject: Re: [PATCH] bcma: use custom printing functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/29 Rafał Miłecki <zajec5@gmail.com>:
> Having bus number printed makes it much easier to anaylze logs on
> systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
> in total, which makes standard log really messy.

John: this applies on top of 5 patches accepted in the
[PATCH 0/8] bcma misc updates
patchset.

So:
wireless-testing +
	bcma: extend workaround for bcm4331
	bcma: add constants for chip ids
	bcma: add PCI ID for BCM43224
	bcma: complete workaround for BCMA43224 and BCM4313
	bcma: add bcma_pmu_spuravoid_pllupdate()

And then:
bcma: use custom printing functions
applies cleanly :)

-- 
Rafał
