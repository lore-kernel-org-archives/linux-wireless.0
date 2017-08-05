Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:35099 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdHEUIq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 16:08:46 -0400
Received: by mail-wr0-f181.google.com with SMTP id k71so26973323wrc.2
        for <linux-wireless@vger.kernel.org>; Sat, 05 Aug 2017 13:08:46 -0700 (PDT)
Subject: Re: [PATCH 04/34] brcmfmac: Clean up brcmf_sdiod_set_sbaddr_window()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-5-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <bb4cc92a-bf63-939b-5245-09afe6e0caa6@broadcom.com> (sfid-20170805_220853_800101_60C792ED)
Date: Sat, 5 Aug 2017 22:08:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-5-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> 	This function sets the address of the IO window used for
> SDIO accesses onto the backplane of the chip.
> 
> It currently uses 3 separate masks despite the full mask being
> defined in the code already. Remove the separate masks and clean up.

No beef here ;-)

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> 
> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c   | 17 +++++------------
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h |  3 ---
>  2 files changed, 5 insertions(+), 15 deletions(-)
