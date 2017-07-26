Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35510 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdGZQFy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 12:05:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH for-4.13] brcmfmac: fix memleak due to calling brcmf_sdiod_sgtable_alloc() twice
References: <1501070969-15984-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Wed, 26 Jul 2017 19:05:49 +0300
In-Reply-To: <1501070969-15984-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Wed, 26 Jul 2017 13:09:24 +0100")
Message-ID: <87k22v18v6.fsf@kamboji.qca.qualcomm.com> (sfid-20170726_180558_102725_29F15CAC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

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

I'll queue this for 4.13.

-- 
Kalle Valo
