Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:39832 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbbAFShC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 13:37:02 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/10] brcmfmac: new device support and more
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
Date: Tue, 06 Jan 2015 20:36:56 +0200
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Sun, 21 Dec 2014 12:43:43 +0100")
Message-ID: <87fvbnycvr.fsf@kamboji.qca.qualcomm.com> (sfid-20150106_193706_828840_9C7C25E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> Here a first batch for v3.20. This series adds support for the
> BCM43340 and BCM43341 SDIO chipsets. A number of changes are
> related to AP mode and some fixes of potential issues that do
> not seem to qualify for the wireless tree.
>
> This series is intended for v3.20 and applies to the master
> branch of the *new* wireless-next repository.
>
> Arend van Spriel (5):
>   brcmfmac: Add support for bcm43340/1 wireless chipsets
>   brcmfmac: get rid of duplicate SDIO device identifiers
>   brcmfmac: remove unused/duplicate defines in chip.c
>   brcmfmac: follow user-space regulatory domain selection
>   brcmfmac: enable 802.11d support in firmware
>
> Hante Meuleman (5):
>   brcmfmac: Fix incorrect casting of 64 bit physical address.
>   brcmfmac: Fix possible dereference of NULL pointer.
>   brcmfmac: Fix WEP configuration for AP mode.
>   brcmfmac: Change error log in standard log for rxbufpost.
>   brcmfmac: signal completion of 802.1x.

I applied these patches:

98027769828f brcmfmac: enable 802.11d support in firmware
6b89dcb35bfc brcmfmac: signal completion of 802.1x.
63db1a499cee brcmfmac: follow user-space regulatory domain selection
d2e2472cd197 brcmfmac: Change error log in standard log for rxbufpost.
118eb304d055 brcmfmac: Fix WEP configuration for AP mode.
f714e58e19a5 brcmfmac: remove unused/duplicate defines in chip.c
83297aaa8fde brcmfmac: Fix incorrect casting of 64 bit physical address.

I dropped two due based on discussion and one patch didn't apply.

-- 
Kalle Valo
