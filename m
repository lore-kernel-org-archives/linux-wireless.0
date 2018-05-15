Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbeEOFhW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 01:37:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180510132139.16279-1-zajec5@gmail.com>
References: <20180510132139.16279-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20180515053721.96D4C60558@smtp.codeaurora.org> (sfid-20180515_073730_945018_3868AE1E)
Date: Tue, 15 May 2018 05:37:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> brcmfmac is a FullMAC driver and it implements/uses cfg80211 interface
> for stations management. At the same time it doesn't receive or pass up
> management frames.
> 
> This flag indicates that authenticator doesn't have to subscribe to or
> handle management frames. Some authenticators (e.g. hostapd) were
> working with brcmfmac thanks to some extra assumptions. This commit
> clears up the situation.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

1204aa17f3b4 brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag

-- 
https://patchwork.kernel.org/patch/10391817/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
