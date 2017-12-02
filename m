Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:65279 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdLBOPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 09:15:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Re-enable TXQs for all devices
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171110004839.7478-1-toke@toke.dk>
References: <20171110004839.7478-1-toke@toke.dk>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
CC: <make-wifi-fast@lists.bufferbloat.net>,
        <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Message-ID: <062afbaa27964709a6d4550aa17a76e3@euamsexm01a.eu.qualcomm.com> (sfid-20171202_151505_352688_0481510F)
Date: Sat, 2 Dec 2017 15:14:53 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen wrote:

> Commit 4ca1807815aa ("ath10k: disable wake_tx_queue for older devices")
> disables the use of the mac80211 TXQs for some devices because of a theoretical
> throughput regression. The original regression report[1] was related to
> fq_codel qdisc drop performance, which was fixed in commit 9d18562a2278
> ("fq_codel: add batch ability to fq_codel_drop()"). Since then, we have not
> seen the TXQ-related regression, so it should be safe to re-enable TXQs.
> 
> [1] http://lists.infradead.org/pipermail/ath10k/2016-April/007266.html
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

170e8e6176d4 ath10k: re-enable TXQs for all devices

-- 
https://patchwork.kernel.org/patch/10052197/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
