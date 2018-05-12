Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40062 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbeELKFH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 06:05:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: add fw crash dump support for QCA9888 and QCA99X0
References: <1525781496-14776-1-git-send-email-akolli@codeaurora.org>
Date: Sat, 12 May 2018 13:05:03 +0300
In-Reply-To: <1525781496-14776-1-git-send-email-akolli@codeaurora.org>
        (Anilkumar Kolli's message of "Tue, 8 May 2018 17:41:36 +0530")
Message-ID: <874ljdur3k.fsf@kamboji.qca.qualcomm.com> (sfid-20180512_120510_721326_1F5B0A0B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> writes:

> This patch adds crash dump support for QCA9888 and QCA99X0
>
> Tested On: QCA9888, Firmware Version: 10.4-3.5.3-00053
> Tested on QCA99X0, Firmware Version: 10.4.1.00030-1
>
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>

[...]

> --- a/drivers/net/wireless/ath/ath10k/coredump.c
> +++ b/drivers/net/wireless/ath/ath10k/coredump.c
> @@ -701,6 +701,89 @@
>  	},
>  };
>  
> +static const struct ath10k_mem_region qca99X0_hw20_mem_regions[] = {

In the pending branch I changed X to lower case and also cleaned up the
commit log a bit:

    ath10k: add memory dump support for QCA9888 and QCA99X0
    
    This patch adds firmware crash memory dump support for QCA9888 and QCA99X0.
    
    Tested on:
    
    QCA9888 firmware 10.4-3.5.3-00053
    QCA99X0 firmware 10.4.1.00030-1


-- 
Kalle Valo
