Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37878 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753428AbdIEVVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:21:23 -0400
Received: by mail-wm0-f49.google.com with SMTP id u26so24143782wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:21:22 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 25/30] brcmfmac: Remove func0 from function array
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-26-ian@mnementh.co.uk>
Message-ID: <6169d65c-70c4-d103-af57-aa6cd2fe5e94@broadcom.com> (sfid-20170905_232126_265834_B91E58C2)
Date: Tue, 5 Sep 2017 23:21:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-26-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Linux doesnt pass you func0 as a function when probing - instead
> providing specific access functions to read/write it.
> 
> This prepares for a patch to remove the actual array entry itself.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> 
> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  5 +----
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 10 +++++++---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 13 ++++++-------
>   3 files changed, 14 insertions(+), 14 deletions(-)
