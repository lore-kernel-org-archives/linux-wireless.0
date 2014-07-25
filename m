Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43244 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbaGYITi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 04:19:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: don't advertise IBSS iftype for 10.x
References: <1406109489-17928-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 25 Jul 2014 11:19:33 +0300
In-Reply-To: <1406109489-17928-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 23 Jul 2014 11:58:09 +0200")
Message-ID: <87d2ctrgtm.fsf@kamboji.qca.qualcomm.com> (sfid-20140725_101942_542472_EA2801AA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The 10.x firmware does not support IBSS mode at
> all. It can't beacon and it crashes when trying to
> scan.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
