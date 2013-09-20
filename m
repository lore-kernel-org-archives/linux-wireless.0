Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30266 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3ITFSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 01:18:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/5] ath10k: tx performance patches
References: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 20 Sep 2013 08:18:40 +0300
In-Reply-To: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 18 Sep 2013 14:43:17 +0200")
Message-ID: <87vc1wgjf3.fsf@qca.qualcomm.com> (sfid-20130920_071856_352383_DD11AD28)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset reduces CPU load and improves
> improves TX performance on AP135 by additional
> 30mbps (give or take; 560mbps -> 590mbps), at
> least on my testbed.
>
>
> Michal Kazior (5):
>   ath10k: use num_pending_tx instead of msdu id bitmap
>   ath10k: avoid needless memset on TX path
>   ath10k: decouple HTT TX completions
>   ath10k: cleanup HTT TX functions
>   ath10k: use msdu headroom to store txfrag

Thanks, all five applied.

-- 
Kalle Valo
