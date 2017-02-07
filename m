Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38864 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbdBGIvq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 03:51:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Add debugfs support to get per peer tids log via tracing
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1485756147-13762-1-git-send-email-c_mkenna@qti.qualcomm.com>
References: <1485756147-13762-1-git-send-email-c_mkenna@qti.qualcomm.com>
To: <c_mkenna@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mkenna@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Message-ID: <6f8d8b25a8d443eabd8f3b6ceb51e24e@eusanexr01a.eu.qualcomm.com> (sfid-20170207_095149_918917_94619224)
Date: Tue, 7 Feb 2017 00:51:41 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_mkenna@qti.qualcomm.com wrote:
> From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> 
> This patch provides support to get per peer tids log.
> 
> echo 1 > /sys/kernel/debug/ieee80211/phyX/netdev\:wlanX/stations/
> XX:XX/peer_debug_trigger
> 
> These logs will be the part of FWLOGS which we collect the logs
> via tracing interface. Here we will get the peer tigd logs only
> once(not repeatedly) when we write 1 to the debugfs file.
> 
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

ee8b08a1be82 ath10k: add debugfs support to get per peer tids log via tracing

-- 
https://patchwork.kernel.org/patch/9544499/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
