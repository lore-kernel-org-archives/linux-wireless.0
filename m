Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36282 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752863AbdHGL0W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:26:22 -0400
Received: by mail-wr0-f173.google.com with SMTP id y43so599773wrd.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:26:21 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 09/34] brcmfmac: Remove noisy debugging.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-10-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E5C.1050007@broadcom.com> (sfid-20170807_132625_455518_ACED85A5)
Date: Mon, 7 Aug 2017 13:26:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-10-ian@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2017 10:25 PM, Ian Molton wrote:
> If you need debugging this low level, you're doing something wrong.
> Remove these noisy debug statements so the code is more readable.

Needing this debugging does not necessarily means you are doing 
something wrong. You may be dealing with hardware that is doing 
something wrong and when that happens this debug can be useful. I 
frankly hardly ever enable SDIO debug level unless I am in that 
scenario. Maybe adding a debug level for low-level access would be 
useful to reduce the noise for SDIO debug level.

Regards,
Arend

> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
