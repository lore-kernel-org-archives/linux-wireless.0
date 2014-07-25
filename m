Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63965 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaGYISg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 04:18:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Denton Gentry <denton.gentry@gmail.com>
Subject: Re: [PATCH v4] ath10k: fix Rx aggregation reordering
References: <1405509540-32691-1-git-send-email-michal.kazior@tieto.com>
	<1406110833-14031-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 25 Jul 2014 11:18:30 +0300
In-Reply-To: <1406110833-14031-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 23 Jul 2014 12:20:33 +0200")
Message-ID: <87ha25rgvd.fsf@kamboji.qca.qualcomm.com> (sfid-20140725_101841_738645_FB9885C6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Firmware doesn't perform Rx reordering so it is
> left to the host driver to do that.
>
> Use mac80211 to perform reordering instead of
> re-inventing the wheel.
>
> This fixes TCP throughput issues in some
> environments.
>
> Reported-by: Denton Gentry <denton.gentry@gmail.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
