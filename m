Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62574 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbbHZIIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 04:08:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix dma_mapping_error() handling
References: <1439982643-27031-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Aug 2015 11:08:04 +0300
In-Reply-To: <1439982643-27031-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 19 Aug 2015 13:10:43 +0200")
Message-ID: <87oahu321n.fsf@kamboji.qca.qualcomm.com> (sfid-20150826_100826_177537_7B691824)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The function returns 1 when DMA mapping fails. The
> driver would return bogus values and could
> possibly confuse itself if DMA failed.
>
> Fixes: 767d34fc67af ("ath10k: remove DMA mapping wrappers")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
