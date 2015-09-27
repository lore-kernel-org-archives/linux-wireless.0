Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26745 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611AbbI0MzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 08:55:12 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix ldpc param for fixed rate
References: <1442389740-29053-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Sun, 27 Sep 2015 15:55:02 +0300
In-Reply-To: <1442389740-29053-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 16 Sep 2015 13:19:00 +0530")
Message-ID: <87bncoc995.fsf@kamboji.qca.qualcomm.com> (sfid-20150927_145517_626724_97F3550D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> ldpc is not configured for fixed rates. This blocks auto rate vs fixed
> rate performance comparison. Since firmware is considering ldpc vdev
> param for fixed rate selection, it has to be configured to enable ldpc
> for fixed rates.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
