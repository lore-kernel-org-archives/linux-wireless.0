Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:37697 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbbHQNkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 09:40:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: wake up offchannel queue properly
References: <1438865214-1651-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 17 Aug 2015 16:40:02 +0300
In-Reply-To: <1438865214-1651-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 6 Aug 2015 14:46:54 +0200")
Message-ID: <8737zif2z1.fsf@kamboji.qca.qualcomm.com> (sfid-20150817_154017_838377_AEBBB2EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Once HTT Tx queue got full offchannel queue was
> stopped and never woken up again. This broke, e.g.
> P2P. This could be reproduced after running a lot
> of traffic enough to saturate 100% of the driver
> Tx queue and then trying to send offchannel
> traffic.
>
> Fixes: 96d828d45e16 ("ath10k: rework tx queue locking")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
