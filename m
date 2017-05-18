Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932314AbdERPrj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 11:47:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [V3, 5/9] brcmfmac: add firmware feature detection for gscan feature
References: <1492776308-15120-6-git-send-email-arend.vanspriel@broadcom.com>
        <20170518133655.91D0660F60@smtp.codeaurora.org>
Date: Thu, 18 May 2017 18:47:35 +0300
In-Reply-To: <20170518133655.91D0660F60@smtp.codeaurora.org> (Kalle Valo's
        message of "Thu, 18 May 2017 13:36:55 +0000 (UTC)")
Message-ID: <87h90i5fqg.fsf@purkki.adurom.net> (sfid-20170518_174805_235425_7D81EDC5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>> From: Arend van Spriel <arend@broadcom.com>
>> 
>> Detect gscan support in firmware by doing pfn_gscan_cfg iovar with
>> invalid version.
>> 
>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>
> Failed to apply:
>
> fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c).
> error: could not build fake ancestor
> Applying: brcmfmac: add support multi-scheduled scan
> Patch failed at 0001 brcmfmac: add support multi-scheduled scan
> The copy of the patch that failed is found in: .git/rebase-apply/patch
>
> 5 patches set to Changes Requested.
>
> 9692541 [V3,5/9] brcmfmac: add firmware feature detection for gscan feature
> 9692537 [V3,6/9] brcmfmac: move scheduled scan wiphy param setting to pno module
> 9692543 [V3,7/9] brcmfmac: add support multi-scheduled scan
> 9692535 [V3,8/9] brcmfmac: add mutex to protect pno requests
> 9692539 [V3,9/9] brcmfmac: add scheduled scan support for specified BSSIDs

Actually I made a mistake and forgot to manually remove patches 5 and 6
from the tree after the conflict (I haven't automated that part yet in
my script). So these are now applied:

9fe929aaace6 brcmfmac: add firmware feature detection for gscan feature
94ed6ffb7965 brcmfmac: move scheduled scan wiphy param setting to pno module

Please resend patches 7-9 and double check that the tree looks ok :)

-- 
Kalle Valo
