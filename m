Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38002 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdHHM3V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 08:29:21 -0400
Received: by mail-wm0-f45.google.com with SMTP id m85so5815278wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 05:29:21 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 33/34] brcmfmac: Remove array of functions
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-34-ian@mnementh.co.uk>
Message-ID: <84583b4f-fad9-f1ee-6390-925d9aa80286@broadcom.com> (sfid-20170808_142924_201642_0E3ADD80)
Date: Tue, 8 Aug 2017 14:29:18 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-34-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> Replace the array of functions with a pair of pointers to the
>  relevant functions.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> 
> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 117 +++++++--------
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 166 ++++++++++-----------
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  15 +-
>  3 files changed, 146 insertions(+), 152 deletions(-)
