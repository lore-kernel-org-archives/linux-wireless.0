Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:13621 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbCGIEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 03:04:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V5 1/2] ath10k: Move ath10k_vdev_stop() up before ath10k_vdev_start_restart()
References: <1425298528-3067-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Sat, 7 Mar 2015 10:04:29 +0200
In-Reply-To: <1425298528-3067-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Mon, 2 Mar 2015 17:45:27
	+0530")
Message-ID: <87oao5z10y.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_093416_973534_F35B12A3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> This patches does not modify any functionality. Just a code move
> so that ath10k_vdev_stop() can be used in ath10k_vdev_start_restart()
> for any failure cases which involves vdev_stop().
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, both patches applied.

-- 
Kalle Valo
