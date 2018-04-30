Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbeD3Knt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:43:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [3/6] brcmfmac: use nl80211_band directly to get ieee80211 channel
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1524737811-1965-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1524737811-1965-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180430104348.9F3B460A00@smtp.codeaurora.org> (sfid-20180430_124520_577173_49B30228)
Date: Mon, 30 Apr 2018 10:43:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Franky Lin <franky.lin@broadcom.com>
> 
> The enum nl80211_band used to retrieve wiphy->bands is the same as
> wiphy->bands->band which is checked by wiphy_register(). So it can be used
> directly as parameter of ieee80211_channel_to_frequency().
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

4 patches applied to wireless-drivers-next.git, thanks.

aed14219067a brcmfmac: use nl80211_band directly to get ieee80211 channel
ff68c9f9c06d brcmfmac: constify firmware mapping tables
84ad327d18de brcmfmac: add hostready indication
f56324baf329 brcmfmac: coarse support for PCIe shared structure rev7

-- 
https://patchwork.kernel.org/patch/10365335/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
