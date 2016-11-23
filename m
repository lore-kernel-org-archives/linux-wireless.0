Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37370 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935089AbcKWNzB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 08:55:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/4] ath10k: implement offset_tsf ieee80211_op
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160928235631.9197-3-twp@qca.qualcomm.com>
References: <20160928235631.9197-3-twp@qca.qualcomm.com>
To: "Pedersen, Thomas" <twp@qca.qualcomm.com>
CC: ath10k <ath10k@lists.infradead.org>,
        Thomas Pedersen <twp@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <5d001697eeb847e887d282d63af3cd40@euamsexm01a.eu.qualcomm.com> (sfid-20161123_145505_222316_2B6E9CE3)
Date: Wed, 23 Nov 2016 14:54:54 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Pedersen, Thomas" <twp@qca.qualcomm.com> wrote:
> Current set_tsf is implemented in terms of TSF_INCREMENT
> only. Instead support new WMI command TSF_DECREMENT and
> export these through offset_tsf. Advantage is we get
> more accurate TSF adjustments, and don't calculate wrong
> offset in case absolute TSF was calculated from rx_mactime
> (actual TSF).
> 
> The new WMI command is available in firmware
> 10.4-3.2.1-00033 for QCA4019 chips. Old drivers on new
> firmware or vice versa shouldn't  be a problem since
> get/set tsf logic was already broken.
> 
> Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

973324fff154 ath10k: implement offset_tsf ieee80211_op
f6f64cfb966d ath10k: remove set/get_tsf ieee80211_ops

-- 
https://patchwork.kernel.org/patch/9355377/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
