Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36457 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdHHMgi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 08:36:38 -0400
Received: by mail-wm0-f50.google.com with SMTP id t201so6056886wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 05:36:38 -0700 (PDT)
Subject: Re: [PATCH 30/34] brcmfmac: Correctly handle accesses to SDIO func0
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-31-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <00c4288e-efea-fc8a-f17b-61c2a28184ae@broadcom.com> (sfid-20170808_143641_873159_69D0D8BD)
Date: Tue, 8 Aug 2017 14:36:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-31-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> Rather than workaround the restrictions on func0 addressing in the
> driver, set MMC_QUIRK_LENIENT_FN0

A quirk sounds like a workaround to me, but as it is provided by the mmc
stack it trumps a driver solution.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 ++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 4 ++--
>  2 files changed, 6 insertions(+), 2 deletions(-)
