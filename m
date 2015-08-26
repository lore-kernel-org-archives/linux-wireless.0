Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18608 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbbHZIGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 04:06:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add missing mutex unlock on failpath
References: <1439982533-26824-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Aug 2015 11:06:40 +0300
In-Reply-To: <1439982533-26824-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 19 Aug 2015 13:08:53 +0200")
Message-ID: <87si76323z.fsf@kamboji.qca.qualcomm.com> (sfid-20150826_100726_542199_15719529)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Kernel would complain about leaving a held lock
> after going back to userspace and would
> subsequently deadlock.
>
> Fixes: e04cafbc38c7 ("ath10k: fix peer limit enforcement")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
