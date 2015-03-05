Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39351 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036AbbCEMMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:12:51 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH next] bcma: make bcma_host_pci_(up|down) calls safe for every config
References: <1425467681-15988-1-git-send-email-zajec5@gmail.com>
Date: Thu, 05 Mar 2015 14:12:44 +0200
In-Reply-To: <1425467681-15988-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 4 Mar 2015
 12:14:41 +0100")
Message-ID: <87egp363sz.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_131258_490771_33EAEE16)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> We were providing declarations but actual code was compiled only with
> CONFIG_BCMA_HOST_PCI set. This could result in:
> ERROR: "bcma_host_pci_down" [drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!
> ERROR: "bcma_host_pci_up" [drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!
> ERROR: "bcma_host_pci_down" [drivers/net/wireless/b43/b43.ko] undefined!
> ERROR: "bcma_host_pci_up" [drivers/net/wireless/b43/b43.ko] undefined!
>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
