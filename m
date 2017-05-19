Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32978 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753420AbdESFDk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 01:03:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [V3, 5/9] brcmfmac: add firmware feature detection for gscan feature
References: <1492776308-15120-6-git-send-email-arend.vanspriel@broadcom.com>
        <20170518133655.91D0660F60@smtp.codeaurora.org>
        <87h90i5fqg.fsf@purkki.adurom.net>
        <fb2b7327-39c6-dc75-e792-e255f8689754@broadcom.com>
Date: Fri, 19 May 2017 08:03:35 +0300
In-Reply-To: <fb2b7327-39c6-dc75-e792-e255f8689754@broadcom.com> (Arend Van
        Spriel's message of "Thu, 18 May 2017 21:34:26 +0200")
Message-ID: <87y3tt8ml4.fsf@codeaurora.org> (sfid-20170519_070352_673560_36102202)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 18-5-2017 17:47, Kalle Valo wrote:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>> 
>>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>>> From: Arend van Spriel <arend@broadcom.com>
>>>>
>>>> Detect gscan support in firmware by doing pfn_gscan_cfg iovar with
>>>> invalid version.
>>>>
>>>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>>>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
>>>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>
>>> Failed to apply:
>>>
>>> fatal: sha1 information is lacking or useless
>>> (drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c).
>>> error: could not build fake ancestor
>>> Applying: brcmfmac: add support multi-scheduled scan
>>> Patch failed at 0001 brcmfmac: add support multi-scheduled scan
>>> The copy of the patch that failed is found in: .git/rebase-apply/patch
>>>
>>> 5 patches set to Changes Requested.
>>>
>>> 9692541 [V3,5/9] brcmfmac: add firmware feature detection for gscan feature
>>> 9692537 [V3,6/9] brcmfmac: move scheduled scan wiphy param setting to pno module
>>> 9692543 [V3,7/9] brcmfmac: add support multi-scheduled scan
>>> 9692535 [V3,8/9] brcmfmac: add mutex to protect pno requests
>>> 9692539 [V3,9/9] brcmfmac: add scheduled scan support for specified BSSIDs
>> 
>> Actually I made a mistake and forgot to manually remove patches 5 and 6
>> from the tree after the conflict (I haven't automated that part yet in
>> my script). So these are now applied:
>> 
>> 9fe929aaace6 brcmfmac: add firmware feature detection for gscan feature
>> 94ed6ffb7965 brcmfmac: move scheduled scan wiphy param setting to pno module
>> 
>> Please resend patches 7-9 and double check that the tree looks ok :)
>
> Will do. These patches were in same series as cfg80211 changes and all
> based on mac80211-next/master. I already mentioned to you and Johannes
> in earlier version of the patch series (posted April 7) that this would
> result in a merge conflict, but I can imagine that info got lost after
> more than a month.

Ah, I remember now. But yeah, too many emails so I tend to forget so old
discussions while looking at patches.

-- 
Kalle Valo
