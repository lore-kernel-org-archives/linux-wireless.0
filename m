Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11576 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaENO0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 10:26:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: fixes 2014-05-14
References: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 14 May 2014 17:26:15 +0300
In-Reply-To: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 14 May 2014 14:16:24 +0200")
Message-ID: <8738gcfnco.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_162626_674518_09D9B6BB)
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
>
> Michal Kazior (2):
>   ath10k: fix core start sequence
>   ath10k: prevent hif_stop being called twice

The patches don't apply anymore and the conflict was not trivial enough
for me to fix it. Can you rebase, please?

(This is the thread I was supposed to reply, sorry for the confusion.)

-- 
Kalle Valo
