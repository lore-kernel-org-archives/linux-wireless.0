Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57546 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdF1Rxa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 13:53:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] brcmfmac: cleanup kerneldoc for struct brcmf_bus
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1498125664-25980-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1498125664-25980-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170628175324.AFD1060DDD@smtp.codeaurora.org> (sfid-20170628_195401_436672_EAF36BFD)
Date: Wed, 28 Jun 2017 17:53:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> A couple of old fields were still described and one field was not
> described.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

4 patches applied to wireless-drivers-next.git, thanks.

ca2e99b2cae9 brcmfmac: cleanup kerneldoc for struct brcmf_bus
a833f3d4de53 brcmfmac: use atomic_t for statistic counter in struct brcmf_bus
270a6c1f65fe brcmfmac: rework headroom check in .start_xmit()
21394d57feba MAINTAINERS: add brcm80211 maintainer info from Cypress

-- 
https://patchwork.kernel.org/patch/9803889/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
