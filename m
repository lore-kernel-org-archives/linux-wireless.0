Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36309 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdHGLL6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:11:58 -0400
Received: by mail-wm0-f45.google.com with SMTP id t201so4423506wmt.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:11:58 -0700 (PDT)
Subject: Re: [PATCH 15/34] brcmfamc: remove unnecessary call to
 brcmf_sdiod_set_backplane_window()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-16-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59884AFC.8090508@broadcom.com> (sfid-20170807_131203_767675_FB584C7F)
Date: Mon, 7 Aug 2017 13:11:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-16-ian@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2017 10:25 PM, Ian Molton wrote:
> All functions that might require the window address changing call
> brcmf_sdiod_set_backplane_window() prior to access. Thus resetting
> the window is not required.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 5 -----
>   1 file changed, 5 deletions(-)
