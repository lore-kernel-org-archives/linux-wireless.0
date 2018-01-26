Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752414AbeAZJU0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 04:20:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] mt76: retry rx polling as long as there is budget left
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180124151917.70962-1-nbd@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180126092026.7A0B160218@smtp.codeaurora.org> (sfid-20180126_102032_579311_BD4F4080)
Date: Fri, 26 Jan 2018 09:20:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Sending frames to mac80211 needs time, which could allow for more rx
> packets to end up in the DMA ring. Retry polling until there are no more
> frames left. Improves rx latency under load.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

7 patches applied to wireless-drivers-next.git, thanks.

2b4307f538ab mt76: retry rx polling as long as there is budget left
1342cfea315a mt76: fix TSF value in probe responses
4e34249e9565 mt76: add an intermediate struct for rx status information
9c68a57bc22d mt76: get station pointer by wcid and pass it to mac80211
aee5b8cf2477 mt76: implement A-MPDU rx reordering in the driver code
9d9d738b4b54 mt76: split mt76_rx_complete
3675302de8e9 mt76: pass the per-vif wcid to the core for multicast rx

-- 
https://patchwork.kernel.org/patch/10182707/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
