Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21973 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaHZQLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 12:11:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix fw crash dumping
References: <1408961594-2440-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 26 Aug 2014 19:11:39 +0300
In-Reply-To: <1408961594-2440-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 25 Aug 2014 12:13:14 +0200")
Message-ID: <87d2bn1b9g.fsf@kamboji.qca.qualcomm.com> (sfid-20140826_181148_682351_0F204F51)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Recent crash dump patches introduced a regression.
> If debugfs was disabled upon crash user could only
> see the following:
>
>  [  793.880000] ath10k: firmware crashed! (uuid n/a)
>  [  793.890000] ath10k: qca988x hw2.0 (0x4100016c, 0x043202ff) fw 10.1.467.2-1 api 2 htt 2.1
>  [  793.890000] ath10k: debug 0 debugfs 0 tracing 0 dfs 1
>
> The report was missing register dump. Fix it by
> printing registers regardless if crash_data is
> present or not.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
