Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754988AbeAIM1w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 07:27:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>
Subject: Re: [09/11] brcmfmac: Remove array of functions
References: <1513687637-5555-10-git-send-email-arend.vanspriel@broadcom.com>
        <20180108172042.EE67E60818@smtp.codeaurora.org>
        <5A54B4BC.4070800@broadcom.com>
Date: Tue, 09 Jan 2018 14:27:48 +0200
In-Reply-To: <5A54B4BC.4070800@broadcom.com> (Arend van Spriel's message of
        "Tue, 9 Jan 2018 13:25:32 +0100")
Message-ID: <87mv1n1akb.fsf@kamboji.qca.qualcomm.com> (sfid-20180109_132758_272647_3260A01D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 1/8/2018 6:20 PM, Kalle Valo wrote:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>
>>> Replace the array of functions with a pair of pointers to the
>>> relevant functions.
>>>
>>> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
>>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> Failed to apply:
>>
>> fatal: sha1 information is lacking or useless
>> (drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c).
>> error: could not build fake ancestor
>> Applying: brcmfmac: Remove array of functions
>> Patch failed at 0001 brcmfmac: Remove array of functions
>> The copy of the patch that failed is found in: .git/rebase-apply/patch
>
> Guess you merged wireless-drivers/master in between.

Actually fast forwarded to latest net-next, so I got the latest
wireless-drivers via that route.

> I just rebased and resolved the conflict and sent a V2 with the
> remaining patches.

Saw them, thanks.

-- 
Kalle Valo
