Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbeH1Rmt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:42:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: Limit available channels via DT
 ieee80211-freq-limit
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180730153933.3771-1-sven.eckelmann@openmesh.com>
References: <20180730153933.3771-1-sven.eckelmann@openmesh.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Message-Id: <20180828135102.EF2336044E@smtp.codeaurora.org> (sfid-20180828_155138_735220_19F1E274)
Date: Tue, 28 Aug 2018 13:51:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> wrote:

> Tri-band devices (1x 2.4GHz + 2x 5GHz) often incorporate special filters in
> the RX and TX path. These filtered channel can in theory still be used by
> the hardware but the signal strength is reduced so much that it makes no
> sense.
> 
> There is already a DT property to limit the available channels but ath10k
> has to manually call this functionality to limit the currrently set wiphy
> channels further.
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

34d5629d2ca8 ath10k: limit available channels via DT ieee80211-freq-limit

-- 
https://patchwork.kernel.org/patch/10549245/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
