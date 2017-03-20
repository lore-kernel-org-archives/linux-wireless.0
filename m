Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754843AbdCTROU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:14:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: always print error when PSM's watchdog fires
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170224163246.7748-1-zajec5@gmail.com>
References: <20170224163246.7748-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170320171402.33B39609F7@smtp.codeaurora.org> (sfid-20170320_181425_324136_43E42487)
Date: Mon, 20 Mar 2017 17:14:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far we were attaching BRCMF_E_PSM_WATCHDOG event listener in
> brcmf_debug_attach which gets compiled only with CONFIG_BRCMDBG. This
> event means something went wrong and firmware / hardware usually can't
> be expected to work (reliably).
> 
> Such a problem is significant for user experience so I believe we should
> print an error unconditionally (even with debugging disabled). What can
> be indeed optional is dumping bus memory as this is clearly part of
> debugging process.
> 
> In the future we may also try to extend this listener by trying to
> recover from the error or at least signal it to the cfg80211.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

f1ac3aa212af brcmfmac: always print error when PSM's watchdog fires

-- 
https://patchwork.kernel.org/patch/9590763/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
