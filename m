Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46756 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934980AbcLTOKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 09:10:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.10,
 1/2] brcmfmac: fix memory leak in brcmf_cfg80211_attach()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1481283254-17883-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1481283254-17883-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20161220141044.72A92611C3@smtp.codeaurora.org> (sfid-20161220_151101_845974_45A099C4)
Date: Tue, 20 Dec 2016 14:10:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> In brcmf_cfg80211_attach() there was one error path not properly
> handled as it leaked memory allocated in brcmf_btcoex_attach().
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

2 patches applied to wireless-drivers.git, thanks.

cb853da3a368 brcmfmac: fix memory leak in brcmf_cfg80211_attach()
2b66325d5ea7 brcmfmac: fix uninitialized field in scheduled scan ssid configuration

-- 
https://patchwork.kernel.org/patch/9467971/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
