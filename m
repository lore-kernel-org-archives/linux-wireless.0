Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:62622 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2Lcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 07:32:35 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: fix/cleanup fw stats
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 29 Sep 2014 14:32:23 +0300
In-Reply-To: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 25 Sep 2014 12:33:46 +0200")
Message-ID: <87d2ae1x2w.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_133239_264246_701E4426)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This cleans up and fixes fw stats aggregation.
>
>
> Michal Kazior (4):
>   ath10k: split wmi stats parsing
>   ath10k: rename fw_stats related stuff
>   ath10k: request fw_stats once on open
>   ath10k: fix fw stats processing

Thanks, applied.

And thank you for fixing this for good, it has been buggy for way too
long.

-- 
Kalle Valo
