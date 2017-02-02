Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdBBGQe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 01:16:34 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] brcmfmac: check brcmf_bus_get_memdump result for error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170130150952.7133-1-zajec5@gmail.com>
References: <20170130150952.7133-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170202061633.47CBA60915@smtp.codeaurora.org> (sfid-20170202_071638_174765_F08DC550)
Date: Thu,  2 Feb 2017 06:16:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This method may be unsupported (see: USB bus) or may just fail (see:
> SDIO bus).
> While at it rework logic in brcmf_sdio_bus_get_memdump function to avoid
> too many conditional code nesting levels.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

2 patches applied to wireless-drivers-next.git, thanks.

f4737a62033d brcmfmac: check brcmf_bus_get_memdump result for error
36401cb7ffae brcmfmac: be more verbose when PSM's watchdog fires

-- 
https://patchwork.kernel.org/patch/9545583/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
