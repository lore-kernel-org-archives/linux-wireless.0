Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28293 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbaJXNbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 09:31:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/9] ath10k: htt rx fixes and clean ups
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 24 Oct 2014 16:30:57 +0300
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 20 Oct 2014 15:40:29 +0200")
Message-ID: <8738adoar2.fsf@kamboji.qca.qualcomm.com> (sfid-20141024_153110_346851_B2EADDF5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> I've found a couple of issues while reworking rx
> path.
>
>
> Michal Kazior (9):
>   ath10k: don't drop control and null func Rx
>   ath10k: remove unused variable
>   ath10k: use ieee80211 defines for crypto param lengths
>   ath10k: fix rx buffer tracing
>   ath10k: deduplicate htt rx dma unmapping
>   ath10k: don't drop frames aggressively
>   ath10k: add extra sanity check when popping amsdu
>   ath10k: don't forget to replenish after fragmented Rx
>   ath10k: clear htt->rx_confused on load

Thanks, all nine applied.

-- 
Kalle Valo
