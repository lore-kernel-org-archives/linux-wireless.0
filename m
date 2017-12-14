Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56493 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752671AbdLNP1k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:27:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2, 1/3] ath10k: remove MAC80211_DEBUGFS dependency on
 ath10k_sta_statistics
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1512480685-28471-2-git-send-email-akolli@qti.qualcomm.com>
References: <1512480685-28471-2-git-send-email-akolli@qti.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <akolli@codeaurora.org>, Anilkumar Kolli <akolli@qti.qualcomm.com>
Message-ID: <7f4e7c29cceb41cd83a8aaa8188f4d0a@euamsexm01a.eu.qualcomm.com> (sfid-20171214_162745_006701_B33213BC)
Date: Thu, 14 Dec 2017 16:27:15 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@qti.qualcomm.com wrote:

> Remove CONFIG_MAC80211_DEBUGFS dependency on ath10k_sta_statistics().
> ath10k_sta_statistics() has per sta tx/rx stats and this should not
> be dependent on MAC80211_DEBUGFS.
> 
> No changes in functionality.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

3 patches applied to ath-next branch of ath.git, thanks.

6a7f891178c2 ath10k: remove MAC80211_DEBUGFS dependency on ath10k_sta_statistics
7f9befbb555d ath10k: move pktlog_filter out of ath10k_debug
e8123bb74c4e ath10k: add per peer tx stats support for 10.2.4

-- 
https://patchwork.kernel.org/patch/10092915/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
