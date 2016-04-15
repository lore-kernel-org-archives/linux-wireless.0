Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58038 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbcDOSdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 14:33:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V11 2/2] brcmfmac: add support for nl80211 BSS_SELECT feature
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
	<1456947439-28968-2-git-send-email-arend@broadcom.com>
Date: Fri, 15 Apr 2016 21:33:25 +0300
In-Reply-To: <1456947439-28968-2-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Wed, 2 Mar 2016 20:37:19 +0100")
Message-ID: <877ffypvre.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_203334_850674_0AD41D47)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> Announce support for nl80211 feature BSS_SELECT and process
> BSS selection behaviour provided in .connect() callback.
>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Lei Zhang <leizh@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Sorry, didn't apply anymore and I don't dare to try to fix the
conflicts:

Applying: brcmfmac: add support for nl80211 BSS_SELECT feature
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c

So please rebase.

-- 
Kalle Valo
