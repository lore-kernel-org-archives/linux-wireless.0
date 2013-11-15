Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1154 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3KOJCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:02:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: remove htt rx amsdu clear retry bit hack
References: <20131113132330.25272.11354.stgit@localhost6.localdomain6>
Date: Fri, 15 Nov 2013 11:01:03 +0200
In-Reply-To: <20131113132330.25272.11354.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Wed, 13 Nov 2013 15:23:30 +0200")
Message-ID: <87mwl63upc.fsf@kamboji.qca.qualcomm.com> (sfid-20131115_100203_455734_D154F53E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> With commit 0cfcefef1 ("mac80211: support reporting A-MSDU subframes
> individually") there's no need to have the hack to clear the retry bit in
> ath10k_htt_rx_amsdu(), mac80211 can handle this properly now.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo
