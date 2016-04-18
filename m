Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39465 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbcDRQNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 12:13:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V11 2/2] brcmfmac: add support for nl80211 BSS_SELECT feature
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
	<1456947439-28968-2-git-send-email-arend@broadcom.com>
	<877ffypvre.fsf@kamboji.qca.qualcomm.com>
	<57139F97.5010106@broadcom.com>
Date: Mon, 18 Apr 2016 19:13:37 +0300
In-Reply-To: <57139F97.5010106@broadcom.com> (Arend van Spriel's message of
	"Sun, 17 Apr 2016 16:37:11 +0200")
Message-ID: <87vb3eki8e.fsf@kamboji.qca.qualcomm.com> (sfid-20160418_181349_182074_AC9BF096)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 15-04-16 20:33, Kalle Valo wrote:
>> Arend van Spriel <arend@broadcom.com> writes:
>> 
>>> Announce support for nl80211 feature BSS_SELECT and process
>>> BSS selection behaviour provided in .connect() callback.
>>>
>>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>> Reviewed-by: Lei Zhang <leizh@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> 
>> Sorry, didn't apply anymore and I don't dare to try to fix the
>> conflicts:
>> 
>> Applying: brcmfmac: add support for nl80211 BSS_SELECT feature
>> Using index info to reconstruct a base tree...
>> Falling back to patching base and 3-way merge...
>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>> CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> 
>> So please rebase.
>
> It probably never applied as I created the patch together with nl80211
> patch on mac80211-next/master branch. Not sure how to handle it
> otherwise.

Yeah, I don't see any better way to do this either and I think the way
you did is best.

> Anyway, I will send out a rebased version soon.

Got it, thanks.

-- 
Kalle Valo
