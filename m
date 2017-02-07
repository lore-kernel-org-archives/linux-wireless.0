Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59324 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdBGH50 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 02:57:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: use wiphy_read_of_freq_limits to respect limits from DT
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170117223550.12114-1-zajec5@gmail.com>
References: <20170117223550.12114-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170207075726.25EC0609FB@smtp.codeaurora.org> (sfid-20170207_085729_558238_9ECACC65)
Date: Tue,  7 Feb 2017 07:57:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This new helper reads extra frequency limits specified in DT and
> disables unavailable chanels. This is useful for devices (like home
> routers) with chipsets limited e.g. by board design.
> 
> In order to respect info read from DT we simply need to check for
> IEEE80211_CHAN_DISABLED bit when constructing channel info.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

0f83ff697356 brcmfmac: use wiphy_read_of_freq_limits to respect limits from DT

-- 
https://patchwork.kernel.org/patch/9522069/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
