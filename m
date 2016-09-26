Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966639AbcIZRiC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 13:38:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/9] brcmfmac: ignore 11d configuration errors
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1474283399-14385-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20160926173801.81A9F6159F@smtp.codeaurora.org> (sfid-20160926_193806_065409_B6AC09C7)
Date: Mon, 26 Sep 2016 17:38:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> From: Hante Meuleman <hante.meuleman@broadcom.com>
> 
> 802.11d is not always supported by firmware anymore. Currently the
> AP configuration of 11d will cause an abort if the ioctl set is
> failing. This behavior is not correct and the error should be
> ignored.
> 
> Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

9 patches applied to wireless-drivers-next.git, thanks.

b3589dfe0212 brcmfmac: ignore 11d configuration errors
704d1c6b56f4 brcmfmac: rework pointer trickery in brcmf_proto_bcdc_query_dcmd()
bc9816413601 brcmfmac: fix memory leak in brcmf_flowring_add_tdls_peer()
26305d3d7298 brcmfmac: initialize variable in brcmf_sdiod_regrl()
8fa5fdec09cd brcmfmac: remove worker from .ndo_set_mac_address() callback
835680b82f02 brcmfmac: remove unnecessary null pointer check
2b7425f3629b brcmfmac: fix clearing entry IPv6 address
a7ed7828ecda brcmfmac: fix out of bound access on clearing wowl wake indicator
92c313604711 brcmfmac: simplify mapping of auth type

-- 
https://patchwork.kernel.org/patch/9339033/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
