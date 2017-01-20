Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdATKEb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 05:04:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,
 1/4] brcmfmac: drop unneeded function declarations from headers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170118104854.32231-1-zajec5@gmail.com>
References: <20170118104854.32231-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170120100430.E5884609E9@smtp.codeaurora.org> (sfid-20170120_110442_198822_0F0C91DC)
Date: Fri, 20 Jan 2017 10:04:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Functions brcmf_c_prec_enq and brcmf_sdio_init don't exist so we
> really don't need their declarations. Function brcmf_parse_tlvs is used
> in cfg80211.c only so make it static and drop from header as well.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

4 patches applied to wireless-drivers-next.git, thanks.

c8d870794d5d brcmfmac: drop unneeded function declarations from headers
f5611e038172 brcmfmac: move brcmf_c_set_joinpref_default declaration to common.h
bfa7295e5b4d brcmfmac: drop brcmf_bus_detach and inline its code
e8cd47501fa0 brcmfmac: rename brcmf_bus_start function to brcmf_bus_started

-- 
https://patchwork.kernel.org/patch/9523097/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
