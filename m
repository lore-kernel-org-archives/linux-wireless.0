Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45564 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757999AbcK2Paq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 10:30:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/12] brcmfmac: add pcie host dongle interface rev6 support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479896731-5091-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20161129153045.68F126134E@smtp.codeaurora.org> (sfid-20161129_163107_984523_8E039032)
Date: Tue, 29 Nov 2016 15:30:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> From: Franky Lin <franky.lin@broadcom.com>
> 
> In rev6 of pcie host dongle interface protocol, host needs to maximum
> supported ring number from dongle shared memory and set up ring buffer
> and ring indices offset accordingly.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

12 patches applied to wireless-drivers-next.git, thanks.

be4b092cab84 brcmfmac: add pcie host dongle interface rev6 support
dc630dc5c753 brcmfmac: add support for 43341 chip
ac55136f43d3 brcmfmac: move pno helper functions in separate source file
3e2e86ab19c2 brcmfmac: fix handling ssids in .sched_scan_start() callback
ab5981c83033 brcmfmac: change prototype for brcmf_do_escan()
fa85b30a9084 brcmfmac: make internal escan more generic
fca6cb2f059e brcmfmac: split up brcmf_pno_config() function
3e48611d31dd brcmfmac: move scheduled scan activation to pno source file
331e78944361 brcmfmac: use provided channels for scheduled scan
dfe5b0d52d58 brcmfmac: remove restriction from .sched_scan_start() callback
c6989fd55ceb brcmfmac: use requested scan interval in scheduled scan
53e3a80d80c8 brcmfmac: fix scheduled scan result handling for newer chips

-- 
https://patchwork.kernel.org/patch/9442895/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
