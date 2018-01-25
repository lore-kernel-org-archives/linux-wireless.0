Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38242 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbeAYFb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 00:31:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: discard undersized packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180117101405.16700-1-nbd@nbd.name>
References: <20180117101405.16700-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, stijn@linux-ipv6.be
Message-Id: <20180125053127.7122060A60@smtp.codeaurora.org> (sfid-20180125_063132_073622_6723A9B7)
Date: Thu, 25 Jan 2018 05:31:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Sometimes the hardware will push small packets that trigger a WARN_ON
> in mac80211. Discard them early to avoid this issue.
> 
> Reported-by: Stijn Tintel <stijn@linux-ipv6.be>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3c0efb745a17 ath9k: discard undersized packets

-- 
https://patchwork.kernel.org/patch/10168963/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
