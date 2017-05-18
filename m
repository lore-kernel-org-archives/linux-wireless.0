Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34503 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754920AbdERTe2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 15:34:28 -0400
Received: by mail-wm0-f46.google.com with SMTP id 70so13591814wmq.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 May 2017 12:34:28 -0700 (PDT)
Subject: Re: [V3, 5/9] brcmfmac: add firmware feature detection for gscan
 feature
To: Kalle Valo <kvalo@codeaurora.org>
References: <1492776308-15120-6-git-send-email-arend.vanspriel@broadcom.com>
 <20170518133655.91D0660F60@smtp.codeaurora.org>
 <87h90i5fqg.fsf@purkki.adurom.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fb2b7327-39c6-dc75-e792-e255f8689754@broadcom.com> (sfid-20170518_213432_863596_BEA82B66)
Date: Thu, 18 May 2017 21:34:26 +0200
MIME-Version: 1.0
In-Reply-To: <87h90i5fqg.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-5-2017 17:47, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>> From: Arend van Spriel <arend@broadcom.com>
>>>
>>> Detect gscan support in firmware by doing pfn_gscan_cfg iovar with
>>> invalid version.
>>>
>>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
>>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> Failed to apply:
>>
>> fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c).
>> error: could not build fake ancestor
>> Applying: brcmfmac: add support multi-scheduled scan
>> Patch failed at 0001 brcmfmac: add support multi-scheduled scan
>> The copy of the patch that failed is found in: .git/rebase-apply/patch
>>
>> 5 patches set to Changes Requested.
>>
>> 9692541 [V3,5/9] brcmfmac: add firmware feature detection for gscan feature
>> 9692537 [V3,6/9] brcmfmac: move scheduled scan wiphy param setting to pno module
>> 9692543 [V3,7/9] brcmfmac: add support multi-scheduled scan
>> 9692535 [V3,8/9] brcmfmac: add mutex to protect pno requests
>> 9692539 [V3,9/9] brcmfmac: add scheduled scan support for specified BSSIDs
> 
> Actually I made a mistake and forgot to manually remove patches 5 and 6
> from the tree after the conflict (I haven't automated that part yet in
> my script). So these are now applied:
> 
> 9fe929aaace6 brcmfmac: add firmware feature detection for gscan feature
> 94ed6ffb7965 brcmfmac: move scheduled scan wiphy param setting to pno module
> 
> Please resend patches 7-9 and double check that the tree looks ok :)

Will do. These patches were in same series as cfg80211 changes and all
based on mac80211-next/master. I already mentioned to you and Johannes
in earlier version of the patch series (posted April 7) that this would
result in a merge conflict, but I can imagine that info got lost after
more than a month.

Regards,
Arend
