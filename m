Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdAaH00 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:26:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2, 2/5] brcmfmac: provide a value for struct
 wowlan_support::max_nd_match_sets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1485520068-5807-3-git-send-email-arend.vanspriel@broadcom.com>
References: <1485520068-5807-3-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170131072526.7A02160A54@smtp.codeaurora.org> (sfid-20170131_082652_241326_1FEED879)
Date: Tue, 31 Jan 2017 07:25:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> The driver advertises support for WOWLAN_NETDETECT but did not specify
> maximum amount of netdetect match sets. This was no issue due to a bug
> in nl80211. As that has been fixed, brcmfmac also needs fixing.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

4 patches applied to wireless-drivers-next.git, thanks.

2ef0359031b9 brcmfmac: provide a value for struct wowlan_support::max_nd_match_sets
d29afe91af59 brcmfmac: fix handling firmware results for wowl netdetect
0b57010fc18e brcmfmac: allow wowlan support to be per device
2a2a5d1835b6 brcmfmac: add .update_connect_params() callback

-- 
https://patchwork.kernel.org/patch/9541755/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
