Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36194 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdH3TkP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:40:15 -0400
Received: by mail-wm0-f42.google.com with SMTP id u126so16028081wmg.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:40:14 -0700 (PDT)
Subject: Re: [PATCH 19/30] brcmfmac: Remove unused macro.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-20-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c9005365-e5f6-f6dd-faa5-06d3d9e2d4e1@broadcom.com> (sfid-20170830_214018_862334_AAB37359)
Date: Wed, 30 Aug 2017 21:40:12 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-20-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> This macro is used exactly nowhere in the code. Delete it.

this removal could have been done in previous patch making that one a 
rename/change of the macro. Anyway....

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 --
>   1 file changed, 2 deletions(-)
