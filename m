Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55358 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbeAZJV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 04:21:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,8/8] mt76: validate rx CCMP PN
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180125104424.90324-1-nbd@nbd.name>
References: <20180125104424.90324-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Message-Id: <20180126092127.15AEE608CB@smtp.codeaurora.org> (sfid-20180126_102132_885817_AFB27497)
Date: Fri, 26 Jan 2018 09:21:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Apparently hardware does not perform CCMP PN validation in hardware, so
> we need to take care of this in the driver. This is important for
> protecting against replay attacks.
> 
> Since validation of fragmented frames is more complex, the CCMP header
> for those is preserved. To keep the counter in sync, the first fragment
> is verified by both mt76 and mac80211, and all other fragments only by
> mac80211.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

30ce7f4456ae mt76: validate rx CCMP PN

-- 
https://patchwork.kernel.org/patch/10183891/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
