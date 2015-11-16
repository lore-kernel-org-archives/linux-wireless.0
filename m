Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19996 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbbKPTvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 14:51:10 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix the wrong RX rate idx report at 11G mode
References: <1447353370-24465-1-git-send-email-yanbol@qca.qualcomm.com>
Date: Mon, 16 Nov 2015 21:50:55 +0200
In-Reply-To: <1447353370-24465-1-git-send-email-yanbol@qca.qualcomm.com>
	(Yanbo Li's message of "Thu, 12 Nov 2015 10:36:10 -0800")
Message-ID: <87a8qd2068.fsf@kamboji.qca.qualcomm.com> (sfid-20151116_205114_270444_6BEC378C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qca.qualcomm.com> writes:

> The RX rate idx is not correctly for 11G mode OFDM packet.
> Because the bitrate table start with CCK index instead of OFDM.
>
> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
