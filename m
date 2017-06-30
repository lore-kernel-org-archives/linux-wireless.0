Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59238 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdF3Gmy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 02:42:54 -0400
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
Message-Id: <20170630064253.DEA8B60A04@smtp.codeaurora.org> (sfid-20170630_084303_580784_670CBB36)
Date: Fri, 30 Jun 2017 06:42:53 +0000 (UTC)
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

Manually applied to wireless-drivers-next, thanks.

b8a64f0e96c2 brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK
2526ff21aa77 brcmfmac: support 4-way handshake offloading for 802.1X
123fef3fd4ae brcmfmac: switch to using cfg80211_connect_done()

There was a simple conflict in feature.h on patch 1 and git was also
auto-merging quite a lot. So please check the resolution in
wireless-drivers-next and let me know if there are any problems.

-- 
https://patchwork.kernel.org/patch/9778339/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
