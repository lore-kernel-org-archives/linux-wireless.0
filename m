Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10906 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbbA2K1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 05:27:39 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix target wakeup timeout
References: <1422290586-10955-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 29 Jan 2015 12:27:30 +0200
In-Reply-To: <1422290586-10955-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 26 Jan 2015 22:13:06 +0530")
Message-ID: <87mw513mr1.fsf@kamboji.qca.qualcomm.com> (sfid-20150129_112747_436415_6D713483)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> During drv_start/drv_stop stress testing in ARM platform,
> sometimes target is taking more that 5ms to wake up. Similar
> behaviour also noted during driver load and unload iterations.
> On such cases, the wakup duration lies between 5-6ms. Hence
> increasing pci wakup timeout 10ms to be more safer. With this
> changes, able to complete power down/up >100 iterations without
> any issues.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
