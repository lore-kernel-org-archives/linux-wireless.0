Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37336 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaKQOi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 09:38:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH v3] ath10k: handle ieee80211 header and payload tracing separately
References: <1415195071-30250-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 17 Nov 2014 16:38:52 +0200
In-Reply-To: <1415195071-30250-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 5 Nov 2014 19:14:31 +0530")
Message-ID: <87egt1q4cj.fsf@kamboji.qca.qualcomm.com> (sfid-20141117_153901_567519_528D5E65)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> For packet log, the transmitted frame 802.11 header alone is sufficient.
> Recording entire packet is also consuming lot of disk space. To optimize
> this, tx and rx data tracepoints are splitted into header and payload
> tracepoints.
>
> To record tx ieee80211 headers
>
>      trace-cmd record -e ath10k_tx_hdr
>
> To record complete packets
>
>      trace-cmd record -e ath10k_tx_hdr -e ath10k_tx_payload
>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
