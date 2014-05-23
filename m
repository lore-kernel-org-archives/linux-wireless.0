Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5882 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaEWIBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:01:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ath10k: fixes 2014-05-14
References: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com>
	<1400136521-11184-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 23 May 2014 11:01:35 +0300
In-Reply-To: <1400136521-11184-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 15 May 2014 08:48:39 +0200")
Message-ID: <87sio0vs80.fsf@kamboji.qca.qualcomm.com> (sfid-20140523_100149_532886_C1D7B960)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This is another pair of patches.
>
> It fixes a crash recently reported by Ben, but..
>
> I've been able to find only a single code path
> that called free_irq() twice in upstream code.
> However it doesn't match the call trace reported
> by Ben. I have to assume this is related to his
> local patches or this is a very wierd case of
> recovery race between userspace/mac80211/driver.
>
> v2:
>  * rebase to latest github.com/kvalo/ath-next-test
>
>
> Michal Kazior (2):
>   ath10k: fix core start sequence
>   ath10k: prevent hif_stop being called twice

Thanks, both patches applied.

-- 
Kalle Valo
