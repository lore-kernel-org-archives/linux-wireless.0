Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35995 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbcDQOhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2016 10:37:15 -0400
Received: by mail-wm0-f52.google.com with SMTP id v188so87525796wme.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2016 07:37:14 -0700 (PDT)
Subject: Re: [PATCH V11 2/2] brcmfmac: add support for nl80211 BSS_SELECT
 feature
To: Kalle Valo <kvalo@codeaurora.org>,
	Arend van Spriel <arend@broadcom.com>
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
 <1456947439-28968-2-git-send-email-arend@broadcom.com>
 <877ffypvre.fsf@kamboji.qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <57139F97.5010106@broadcom.com> (sfid-20160417_163722_639749_1DD7B328)
Date: Sun, 17 Apr 2016 16:37:11 +0200
MIME-Version: 1.0
In-Reply-To: <877ffypvre.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 15-04-16 20:33, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
> 
>> Announce support for nl80211 feature BSS_SELECT and process
>> BSS selection behaviour provided in .connect() callback.
>>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Lei Zhang <leizh@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> 
> Sorry, didn't apply anymore and I don't dare to try to fix the
> conflicts:
> 
> Applying: brcmfmac: add support for nl80211 BSS_SELECT feature
> Using index info to reconstruct a base tree...
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> 
> So please rebase.

It probably never applied as I created the patch together with nl80211
patch on mac80211-next/master branch. Not sure how to handle it
otherwise. Anyway, I will send out a rebased version soon.

Regards,
Arend
