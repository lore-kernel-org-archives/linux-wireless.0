Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53369 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbcBFLxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 06:53:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 0/5] brcmfmac: support for new 14e43:4365 card with BCM4366
References: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
Date: Sat, 06 Feb 2016 13:53:13 +0200
In-Reply-To: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Tue, 26 Jan 2016
 17:57:00 +0100")
Message-ID: <87mvreukba.fsf@kamboji.qca.qualcomm.com> (sfid-20160206_125323_216987_536E4A5A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> I got D-Link DIR-885L with two 14e4:4365 PCI cards both using BCM4366 chipset.
> It seems to have newer ChipCommon and separated PMU core so I needed these
> patches on top of recent Broadcom's work.
>
> Please note this patchset depends on:
> [PATCH 2/2] bcma: support PMU present as separated bus core
> as I had to use BCMA_CC_CAP_EXT_AOB_PRESENT.
>
> Rafał Miłecki (5):
>   brcmfmac: analyze descriptors of current component only
>   brcmfmac: allow storing PMU core without wrapper address
>   brcmfmac: read extended capabilities of ChipCommon core
>   brcmfmac: access PMU registers using standalone PMU core if available
>   brcmfmac: add support for 14e4:4365 PCI ID with BCM4366 chipset

Manually applied all five to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
