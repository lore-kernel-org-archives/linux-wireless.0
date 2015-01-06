Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:39716 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbbAFSfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 13:35:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 04/10] brcmfmac: get rid of duplicate SDIO device identifiers
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
	<1419162233-19492-5-git-send-email-arend@broadcom.com>
Date: Tue, 06 Jan 2015 20:35:39 +0200
In-Reply-To: <1419162233-19492-5-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Sun, 21 Dec 2014 12:43:47 +0100")
Message-ID: <87k30zycxw.fsf@kamboji.qca.qualcomm.com> (sfid-20150106_193550_890957_41ED3392)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> Instead of defining SDIO device identifier in brcm80211 code use
> the defintions in linux/mmc/sdio_ids.h directly.
>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

I tried to apply this but got:

Applying: brcmfmac: get rid of duplicate SDIO device identifiers
error: patch failed: drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:996
error: drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c: patch does not apply
error: patch failed: drivers/net/wireless/brcm80211/include/brcm_hw_ids.h:46
error: drivers/net/wireless/brcm80211/include/brcm_hw_ids.h: patch does not apply
Patch failed at 0001 brcmfmac: get rid of duplicate SDIO device identifiers

Please resend.

-- 
Kalle Valo
