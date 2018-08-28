Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbeH1R06 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:26:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] ath10k: add extended per sta tx statistics support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533561223-342-4-git-send-email-akolli@codeaurora.org>
References: <1533561223-342-4-git-send-email-akolli@codeaurora.org>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180828133516.A3D0F6053D@smtp.codeaurora.org> (sfid-20180828_153523_397478_F959F974)
Date: Tue, 28 Aug 2018 13:35:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> wrote:

> This patch adds per station tx statistics support.
> 
> Per station tx stats include
>  - pkts/bytes transmitted at all possible rates(mcs/nss/bw/gi).
>  - ACK fails count
>  - ampdu bytes/pkts transmitted at all possible rates(mcs/nss/bw/gi).
>  - BA fails count
> 
> Tested on QCA9984/QCA4019/QCA988x
> Firmware: 10.4-3.5.3-00057
> 	  10.2.4-1.0-00037
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

kbuild bot found a new warning:

   drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_sta_state':
>> drivers/net/wireless/ath/ath10k/mac.c:6335:9: error: 'struct ath10k' has no member named 'debug'
      if (ar->debug.enable_extd_tx_stats)
            ^~

-- 
https://patchwork.kernel.org/patch/10557073/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
