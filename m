Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17920 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3GaGHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 02:07:06 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: detect the number of spatial streams supported by hw
References: <1374662206-19198-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 31 Jul 2013 09:06:58 +0300
In-Reply-To: <1374662206-19198-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 24 Jul 2013 12:36:46 +0200")
Message-ID: <87a9l3s1od.fsf@kamboji.qca.qualcomm.com> (sfid-20130731_080710_073006_E231E733)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Until now ath10k assumed 3 spatial streams.
> However some devices support only 2 spatial
> streams.
>
> This patch improves performance on devices that
> don't support 3 spatial streams.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
