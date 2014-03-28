Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49020 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaC1MRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 08:17:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: update wal_dbg_tx_stats structure with missing parameter
References: <1395648122-2125-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 28 Mar 2014 14:17:14 +0200
In-Reply-To: <1395648122-2125-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Mon, 24 Mar 2014 16:02:02 +0800")
Message-ID: <87ha6iwm9h.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_131723_390735_161B0E59)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> This patch is introduced by Bartosz Markowski but never upstream.
> By using this patch, 636 firmware is able to print out the peer
> stats correctly and have caused no regression to the latest AP
> firmware as well.
>
> The original patch from Bartosz Markowski can be found at:
> http://lists.infradead.org/pipermail/ath10k/2013-September/000318.html
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

I'm going to apply the original patch instead and I'll drop this.

-- 
Kalle Valo
