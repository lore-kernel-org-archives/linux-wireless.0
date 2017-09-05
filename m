Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33499 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753422AbdIEVVP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:21:15 -0400
Received: by mail-wm0-f42.google.com with SMTP id f145so13368572wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:21:14 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 24/30] brcmfmac: Correctly handle accesses to SDIO func0
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-25-ian@mnementh.co.uk>
Message-ID: <703a3be2-d3f6-dcb5-5fdf-060cbf4b1163@broadcom.com> (sfid-20170905_232121_770810_B2091AA9)
Date: Tue, 5 Sep 2017 23:21:12 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-25-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Rather than workaround the restrictions on func0 addressing in the
> driver, set MMC_QUIRK_LENIENT_FN0

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 ++++
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 4 ++--
>   2 files changed, 6 insertions(+), 2 deletions(-)
