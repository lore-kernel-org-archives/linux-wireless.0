Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43890 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdDMOGo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 10:06:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: properly align buffers on certain platforms with 64 bit
 DMA
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <7120e0d6-8687-2622-7432-cb78dae3e122@gmail.com>
References: <7120e0d6-8687-2622-7432-cb78dae3e122@gmail.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Helmut Klein <hgkr.klein@gmail.com>
Message-Id: <20170413140644.45B2660D70@smtp.codeaurora.org> (sfid-20170413_160650_484205_DD9236CE)
Date: Thu, 13 Apr 2017 14:06:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heiner Kallweit <hkallweit1@gmail.com> wrote:
> Systems with 64 bit DMA at least partially require buffers to be used
> for DMA to be 8-byte-aligned. One example is Amlogic Meson GX.
> Switching the MMC/SDIO driver for this platform to SG DMA mode
> resulted in problems due to unaligned buffers.
> 
> Fortunately the brcmfmac driver has a global define for the alignment.
> Changing it to 8 fixed the issues with Meson GX.
> 
> Suggested-by: Helmut Klein <hgkr.klein@gmail.com>
> Tested-by: Helmut Klein <hgkr.klein@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

6e84ab604bde brcmfmac: properly align buffers on certain platforms with 64 bit DMA

-- 
https://patchwork.kernel.org/patch/9665425/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
