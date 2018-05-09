Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933715AbeEIKZM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 06:25:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: Add support for bcm43364 wireless chipset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525416503-832-1-git-send-email-sean@lano.id.au>
References: <1525416503-832-1-git-send-email-sean@lano.id.au>
To: Sean Lanigan <sean@lano.id.au>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, ulf.hansson@linaro.org,
        ian@mnementh.co.uk, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@cypress.com, linux-mmc@vger.kernel.org,
        Sean Lanigan <sean@lano.id.au>
Message-Id: <20180509102511.E97F160FA8@smtp.codeaurora.org> (sfid-20180509_122516_089907_0C55CA5B)
Date: Wed,  9 May 2018 10:25:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sean Lanigan <sean@lano.id.au> wrote:

> Add support for the BCM43364 chipset via an SDIO interface, as used in 
> e.g. the Murata 1FX module. 
> 
> The BCM43364 uses the same firmware as the BCM43430 (which is already 
> included), the only difference is the omission of Bluetooth. 
> 
> However, the SDIO_ID for the BCM43364 is 02D0:A9A4, giving it a MODALIAS 
> of sdio:c00v02D0dA9A4, which doesn't get recognised and hence doesn't 
> load the brcmfmac module. Adding the 'A9A4' ID in the appropriate place 
> triggers the brcmfmac driver to load, and then correctly use the 
> firmware file 'brcmfmac43430-sdio.bin'. 
> 
> 
> Signed-off-by: Sean Lanigan <sean@lano.id.au>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Patch applied to wireless-drivers-next.git, thanks.

9c4a121e8263 brcmfmac: Add support for bcm43364 wireless chipset

-- 
https://patchwork.kernel.org/patch/10380047/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
