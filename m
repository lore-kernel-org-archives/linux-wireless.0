Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49931 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3KFIuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 03:50:25 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <linville@tuxdriver.com>, <yongjun_wei@trendmicro.com.cn>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH -next] ath10k: fix possible memory leak in ath10k_pci_probe()
References: <CAPgLHd9o1oGjjM=9B2H0tB41t8Kinp_1Djp6aA=sW5Eo5M7jfA@mail.gmail.com>
Date: Wed, 6 Nov 2013 10:50:19 +0200
In-Reply-To: <CAPgLHd9o1oGjjM=9B2H0tB41t8Kinp_1Djp6aA=sW5Eo5M7jfA@mail.gmail.com>
	(Wei Yongjun's message of "Wed, 30 Oct 2013 13:24:39 +0800")
Message-ID: <87fvr9ud6c.fsf@kamboji.qca.qualcomm.com> (sfid-20131106_095031_111177_3C2912E2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> writes:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> memory is malloced in ath10k_pci_probe() and should be freed before
> leaving from the error handling cases, otherwise it will cause
> memory leak.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, applied.

-- 
Kalle Valo
