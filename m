Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750842AbeDXRab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:30:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/7] mt76: stop tx queues from the driver callback instead of
 common code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180403195254.87700-1-nbd@nbd.name>
References: <20180403195254.87700-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180424173031.67D7760131@smtp.codeaurora.org> (sfid-20180424_193035_566406_077C827C)
Date: Tue, 24 Apr 2018 17:30:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Allows the driver to control whether to send a BlockAckReq after waking
> up. MT76x2 needs this set to true, for MT7603 (to be submitted later)
> it needs to be false.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

7 patches applied to wireless-drivers-next.git, thanks.

11b2a25f02b7 mt76: stop tx queues from the driver callback instead of common code
49149d3f1c6b mt76: add missing VHT maximum A-MPDU length capability
9f67c277a80f mt76: toggle driver station powersave bit before notifying mac80211
80f28994f7d9 mt76: rework tx power handling
07073a2768ac mt76: fix potential sleep in atomic context
18efed59fabc mt76: set RX_FLAG_DUP_VALIDATED for A-MPDU reordered packets
1af83148a4fc mt76: check qos ack policy before reordering packets

-- 
https://patchwork.kernel.org/patch/10321713/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
