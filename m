Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755919AbeDXGBy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 02:01:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Enable hw checksum for wcn3990
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523957066-12585-1-git-send-email-pillair@codeaurora.org>
References: <1523957066-12585-1-git-send-email-pillair@codeaurora.org>
To: Rakesh Pillai <pillair@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Message-Id: <20180424060153.A00CD60863@smtp.codeaurora.org> (sfid-20180424_080158_184605_9F2C1AFD)
Date: Tue, 24 Apr 2018 06:01:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@codeaurora.org> wrote:

> By default ath10k driver enables the support for HW_CHECKSUM
> (NETIF_F_HW_CSUM). Since the TCP/UDP checksum calculation is not enabled
> in the wcn3990 firmware the checksum is incorrect in the TCP/UDP packets
> and all patckets are dropped. But due note that wcn3990 support in
> ath10k is still incomplete so this isn't a critical fix (yet).
> 
> Enable hw checksum calculations in wcn3990 hardware by
> setting the proper flags in msdu descriptor tso flags.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

20529b33aa12 ath10k: enable hw checksum for wcn3990

-- 
https://patchwork.kernel.org/patch/10344621/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
