Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35159 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbeEMSti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 May 2018 14:49:38 -0400
Received: by mail-wm0-f67.google.com with SMTP id o78-v6so11324491wmg.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2018 11:49:37 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180510132139.16279-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AF888C0.7020506@broadcom.com> (sfid-20180513_204941_997008_5F167967)
Date: Sun, 13 May 2018 20:49:36 +0200
MIME-Version: 1.0
In-Reply-To: <20180510132139.16279-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/10/2018 3:21 PM, Rafał Miłecki wrote:
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

Thanks for this patch.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
>   1 file changed, 1 insertion(+)
