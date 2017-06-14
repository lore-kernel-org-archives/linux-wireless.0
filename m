Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754241AbdFNFKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 01:10:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V3,
 6/9] brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1497010130-16186-7-git-send-email-arend.vanspriel@broadcom.com>
References: <1497010130-16186-7-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170614050959.8A19B60851@smtp.codeaurora.org> (sfid-20170614_071010_735737_98358254)
Date: Wed, 14 Jun 2017 05:09:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Arend van Spriel <arend@broadcom.com>
> 
> The firmware may have supplicant code built-in. This is detected
> by the driver and indicated in the wiphy features flags. User-space
> can use this flag to determine whether or not to provide the
> pre-shared key material in the nl80211 CONNECT command.
> 
> Reviewed-by: Gautam (Gautam Kumar) Shukla <gautams@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Depends on:

3a00df5707b6 cfg80211: support 4-way handshake offloading for 802.1X

Currently in net-next.

-- 
https://patchwork.kernel.org/patch/9778339/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
