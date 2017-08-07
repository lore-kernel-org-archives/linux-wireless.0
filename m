Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37027 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752843AbdHGLZz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:25:55 -0400
Received: by mail-wm0-f49.google.com with SMTP id t201so4621679wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:25:55 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 06/34] brcmfmac: Remove bandaid for SleepCSR
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-7-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E41.2050100@broadcom.com> (sfid-20170807_132558_061654_00664337)
Date: Mon, 7 Aug 2017 13:25:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-7-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> Register access code is not the place for band-aid fixes like this.
> If this is a genuine problem, it should be fixed further up in the driver
> stack.

So lets make it a SDIO debug message for all register accesses getting
rid of the error message.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
>
> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 28 +---------------------
>  1 file changed, 1 insertion(+), 27 deletions(-)
