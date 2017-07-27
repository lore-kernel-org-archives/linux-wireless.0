Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56838 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbdG0LDi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 07:03:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.13] brcmfmac: fix memleak due to calling
 brcmf_sdiod_sgtable_alloc() twice
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1501070969-15984-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1501070969-15984-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170727110338.5E36560908@smtp.codeaurora.org> (sfid-20170727_130342_269326_A836F29C)
Date: Thu, 27 Jul 2017 11:03:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Due to a bugfix in wireless tree and the commit mentioned below a merge
> was needed which went haywire. So the submitted change resulted in the
> function brcmf_sdiod_sgtable_alloc() being called twice during the probe
> thus leaking the memory of the first call.
> 
> Cc: stable@vger.kernel.org # 4.6.x
> Fixes: 4d7928959832 ("brcmfmac: switch to new platform data")
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

5f5d03143de5 brcmfmac: fix memleak due to calling brcmf_sdiod_sgtable_alloc() twice

-- 
https://patchwork.kernel.org/patch/9864681/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
