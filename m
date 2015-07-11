Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40661 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbGKQVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 12:21:35 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix target to cpu address conversion logic
References: <1435931727-300-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Sat, 11 Jul 2015 19:21:30 +0300
In-Reply-To: <1435931727-300-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Fri, 3 Jul 2015 19:25:27
	+0530")
Message-ID: <871tgewtpx.fsf@kamboji.qca.qualcomm.com> (sfid-20150711_182138_504552_BA50ABBF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> 'commit 418ca5992e2f ("ath10k: Make target cpu address to
> CE address conversion chip specific")' mask 0x7fff is added
> by mistake instead of 0x7ff. Fix this regression.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
