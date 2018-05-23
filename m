Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754214AbeEWH73 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 03:59:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] mt76: only stop tx queues on offchannel,
 not during the entire scan
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180520054349.49422-1-nbd@nbd.name>
References: <20180520054349.49422-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180523075929.2356E60618@smtp.codeaurora.org> (sfid-20180523_100309_778386_9138E90C)
Date: Wed, 23 May 2018 07:59:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> During scans, mac80211 frequently switches back to the home channel to
> minimize interruption of ongoing traffic. Keep regular tx queues active
> during that time.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

5 patches applied to wireless-drivers-next.git, thanks.

89bc67e3a93a mt76: only stop tx queues on offchannel, not during the entire scan
a164a94212ce mt76: prevent tx scheduling during channel change
a85b590cf55f mt76: move ieee80211_hw allocation to common core
26e40d4c0b52 mt76: wait for pending tx to complete before switching channel
cbec83d40cc7 mt76: use udelay instead of usleep_range in mt76x2_mac_stop

-- 
https://patchwork.kernel.org/patch/10413117/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
