Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53104 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbdGUHlI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 03:41:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.13] brcmfmac: fix regression in brcmf_sdio_txpkt_hdalign()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1499851968-18768-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1499851968-18768-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170721074108.7D39E60AD5@smtp.codeaurora.org> (sfid-20170721_094235_237365_418A3812)
Date: Fri, 21 Jul 2017 07:41:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Recent change in brcmf_sdio_txpkt_hdalign() changed the
> behavior and now always returns 0. This resulted in a
> regression which basically renders the device useless.
> 
> Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
> Reported-by: S. Gilles <sgilles@math.umd.edu>
> Tested-by: S. Gilles <sgilles@math.umd.edu>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

0a16628212b8 brcmfmac: fix regression in brcmf_sdio_txpkt_hdalign()

-- 
https://patchwork.kernel.org/patch/9836383/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
