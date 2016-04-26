Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5366 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbcDZMFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 08:05:43 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH] ath10k: release pre_cal_file while unloading driver
Date: Tue, 26 Apr 2016 12:05:26 +0000
Message-ID: <87inz4y3qy.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_140547_520788_4E91D38E)
References: <1461660217-23046-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1461660217-23046-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 26 Apr 2016 14:13:37 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Failing to release pre_cal_file caldata on deinit causes memory leak.
>
> Fixes: b131129d9657 ("ath10k: fix calibration init sequence of qca99x0")
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Doesn't apply, please rebase.

Applying: ath10k: release pre_cal_file while unloading driver
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/core.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 ath10k: release pre_cal_file while unloading driver

-- 
Kalle Valo