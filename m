Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53559 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034478AbcIZRtf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 13:49:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: fix memory leak in brcmf_fill_bss_param
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160921062327.28729-1-zajec5@gmail.com>
References: <20160921062327.28729-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Message-Id: <20160926174934.8AC1B61650@smtp.codeaurora.org> (sfid-20160926_194940_079253_9F7688DA)
Date: Mon, 26 Sep 2016 17:49:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This function is called from get_station callback which means that every
> time user space was getting/dumping station(s) we were leaking 2 KiB.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Fixes: 1f0dc59a6de ("brcmfmac: rework .get_station() callback")
> Cc: stable@vger.kernel.org # 4.2+
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

23e9c128adb2 brcmfmac: fix memory leak in brcmf_fill_bss_param

-- 
https://patchwork.kernel.org/patch/9342879/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
