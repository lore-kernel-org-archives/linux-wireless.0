Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbeBAIou (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 03:44:50 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4.16,1/4] mt76: implement AP_LINK_PS
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180127150206.24690-1-nbd@nbd.name>
References: <20180127150206.24690-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180201084449.E264C6014B@smtp.codeaurora.org> (sfid-20180201_094453_833077_980F0782)
Date: Thu,  1 Feb 2018 08:44:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> With software A-MPDU reordering in place, frames that notify mac80211 of
> powersave changes are reordered as well, which can cause connection
> stalls. Fix this by implementing powersave state processing in the
> driver.
> 
> Fixes: aee5b8cf2477 ("mt76: implement A-MPDU rx reordering in the driver code")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

4 patches applied to wireless-drivers-next.git, thanks.

d71ef28636e4 mt76: implement AP_LINK_PS
17cf68b702a6 mt76: implement processing of BlockAckReq frames
fb208dc73ff1 mt76: avoid re-queueing A-MPDU rx reorder work if no frames are pending
cbbde7e8d985 mt76: do not set status->aggr for NULL data frames

-- 
https://patchwork.kernel.org/patch/10187533/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
