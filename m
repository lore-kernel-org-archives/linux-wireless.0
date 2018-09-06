Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34950 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbeIFUl4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:41:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2 3/3] ath10k: average ack rssi support for data frames
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523890122-23952-4-git-send-email-bpothuno@codeaurora.org>
References: <1523890122-23952-4-git-send-email-bpothuno@codeaurora.org>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, bpothuno@codeaurora.org
Message-Id: <20180906160545.444CD601D9@smtp.codeaurora.org> (sfid-20180906_180547_926530_C138D87A)
Date: Thu,  6 Sep 2018 16:05:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Balaji Pothunoori <bpothuno@codeaurora.org> wrote:

> Average ack rssi value is weighted average of ack rssi for
> no of msdu's has been sent.
> This feature is enabled by the host driver if firmware is capable.
> After receiving event from host, firmware allocates the necessary
> memory to store the ack_rssi for data packets during the init time.
> 
> After each successful transmission, If tx completion status is OK
> and 24th bit is set in HTT message header then host will fetch the
> ack_rssi else host can ignore the ack_rssi field.
> 
> Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c7fd8d237e2e ath10k: average ack rssi support for data frames

-- 
https://patchwork.kernel.org/patch/10343153/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
