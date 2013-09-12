Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33296 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3ILQtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 12:49:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] ath10k: improve TX path
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 12 Sep 2013 19:48:59 +0300
In-Reply-To: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 10 Sep 2013 15:49:56 +0200")
Message-ID: <87ob7ydlz8.fsf@qca.qualcomm.com> (sfid-20130912_184924_736091_EF072546)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset addresses two issues:
>
>  * system/userspace starvation on heavy briding
>    UDP TX
>  * unstable/inconsistent UDP TX throughput
>
> In short the patchset simplifies TX path by
> removing HTC TX workers, makes WMI commands block
> and makes ath10k more responsive to queues
> becoming full. This contributes to both improved
> throughput and makes the system more responsive
> under heavy UDP TX load.

This looks very good, it's great that we can get rid of the TX workers.
Please submit v2 and I'll apply these.

-- 
Kalle Valo
