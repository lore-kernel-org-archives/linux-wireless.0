Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53293 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcBFLth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 06:49:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] bcma: claim only 14e4:4365 PCI Dell card with SoftMAC BCM43142
References: <1453824129-9645-1-git-send-email-zajec5@gmail.com>
Date: Sat, 06 Feb 2016 13:49:31 +0200
In-Reply-To: <1453824129-9645-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Tue, 26 Jan 2016
 17:02:09 +0100")
Message-ID: <87r3gqukhg.fsf@kamboji.qca.qualcomm.com> (sfid-20160206_124940_057154_D1D71FDA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> It seems 14e4:4365 pattern is too generic as there are two devices:
> 1) 14e4:4365 1028:0016 with SoftMAC BCM43142 chipset
> 2) 14e4:4365 14e4:4365 with FullMAC BCM4366 chipset
> The later one was found in D-Link DIR-885L router and we want to let
> brcmfmac handle it.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Manually applied to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
