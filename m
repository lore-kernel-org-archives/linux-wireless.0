Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:39779 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbeB1JHu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 04:07:50 -0500
Received: by mail-qt0-f194.google.com with SMTP id f4so2045135qtj.6
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 01:07:50 -0800 (PST)
Subject: Re: [PATCH 1/2] brcmfmac: add possibility to obtain firmware error
To: Kalle Valo <kvalo@codeaurora.org>
References: <1519774940-20793-1-git-send-email-arend.vanspriel@broadcom.com>
 <1519774940-20793-2-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A967163.7010206@broadcom.com> (sfid-20180228_100758_353253_67F751B5)
Date: Wed, 28 Feb 2018 10:07:47 +0100
MIME-Version: 1.0
In-Reply-To: <1519774940-20793-2-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/28/2018 12:42 AM, Arend van Spriel wrote:
> The feature module needs to evaluate the actual firmware error returned
> upon a control command. This adds a field to struct brcmf_if in which
> the error code is stored whenever a firmware error occurs.

Hi Kalle,

Can you drop this one. It was way too late for me so I screwed it up. If 
needed I will resend both patches. Let me know.

Regards,
Arend

> Fixes: b69c1df47281 ("brcmfmac: separate firmware errors from i/o errors")
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h    | 2 ++
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 2 +-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c    | 1 +
>   3 files changed, 4 insertions(+), 1 deletion(-)
