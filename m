Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50500 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbdHHLv4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:51:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/3] brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/OPEN security
 mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com
Message-Id: <20170808115155.17B4A60708@smtp.codeaurora.org> (sfid-20170808_135159_083900_DBD5D795)
Date: Tue,  8 Aug 2017 11:51:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> wrote:

> When setting wpa_auth to WPA_AUTH_NONE(1) in AP mode with WEP security,
> firmware will set privacy bit and add WPA OUI in VENDOR IE in beacon and
> probe response. The security type in softAP beacons confuse the
> supplicant in client side, and the user client will see [WPA-?] in
> supplicant scan result. So we set WPA_AUTH_DISABLED in softAP mode with 
> OPEN security.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

3 patches applied to wireless-drivers-next.git, thanks.

fdfb0f94bfb7 brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/OPEN security mode
0ec9eb90feec brcmfmac: Add support for CYW4373 SDIO/USB chipset
99976fc08412 brcmfmac: fix wrong num_different_channels when mchan feature enabled

-- 
https://patchwork.kernel.org/patch/9878545/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
