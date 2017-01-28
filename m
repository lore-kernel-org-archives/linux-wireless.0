Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51190 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdA1Ghb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 01:37:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: drop duplicated core selection from brcmf_pcie_attach
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170119095125.12276-1-zajec5@gmail.com>
References: <20170119095125.12276-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Hante Meuleman <meuleman@broadcom.com>
Message-Id: <20170128063718.7D3066089D@smtp.codeaurora.org> (sfid-20170128_073907_086142_BB185473)
Date: Sat, 28 Jan 2017 06:37:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> It was left after reworking PCIe reset in commit 07fe2e38c7fd
> ("brcmfmac: Reset PCIE devices after recognition.").
> 
> Cc: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

b3d75a81f07c brcmfmac: drop duplicated core selection from brcmf_pcie_attach

-- 
https://patchwork.kernel.org/patch/9525365/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
