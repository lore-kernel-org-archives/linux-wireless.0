Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33796 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754651AbeAIMZe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 07:25:34 -0500
Received: by mail-qt0-f196.google.com with SMTP id 33so17538252qtv.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jan 2018 04:25:34 -0800 (PST)
Subject: Re: [09/11] brcmfmac: Remove array of functions
To: Kalle Valo <kvalo@codeaurora.org>
References: <1513687637-5555-10-git-send-email-arend.vanspriel@broadcom.com>
 <20180108172042.EE67E60818@smtp.codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A54B4BC.4070800@broadcom.com> (sfid-20180109_132537_900227_DEC1DD78)
Date: Tue, 9 Jan 2018 13:25:32 +0100
MIME-Version: 1.0
In-Reply-To: <20180108172042.EE67E60818@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/8/2018 6:20 PM, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>
>> Replace the array of functions with a pair of pointers to the
>> relevant functions.
>>
>> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>
> Failed to apply:
>
> fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c).
> error: could not build fake ancestor
> Applying: brcmfmac: Remove array of functions
> Patch failed at 0001 brcmfmac: Remove array of functions
> The copy of the patch that failed is found in: .git/rebase-apply/patch

Guess you merged wireless-drivers/master in between. I just rebased and 
resolved the conflict and sent a V2 with the remaining patches.

> 3 patches set to Changes Requested.
>
> 10123215 [09/11] brcmfmac: Remove array of functions
> 10123207 [10/11] brcmfmac: add comment block in brcmf_sdio_buscore_read()
> 10123205 [11/11] brcmfmac: rename brcmf_sdiod_buff_{read,write}() functions
>

Thanks,
Arend
