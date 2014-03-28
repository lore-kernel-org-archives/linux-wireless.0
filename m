Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18395 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaC1PCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 11:02:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: update wal_dbg_tx_stats structure with missing parameter.
References: <20140328121639.4591.17459.stgit@potku.adurom.net>
Date: Fri, 28 Mar 2014 17:02:16 +0200
In-Reply-To: <20140328121639.4591.17459.stgit@potku.adurom.net> (Kalle Valo's
	message of "Fri, 28 Mar 2014 14:16:39 +0200")
Message-ID: <8738i2v01z.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_160224_720633_EC7CADA9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> The filed has been missing (missmatched with FW ABI)
> since 999.999.0.629 firmware release.
>
> It's very imporatant to keep these structs up to date with FW,
> due to the arithmetic we use while read the fw_stats.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
