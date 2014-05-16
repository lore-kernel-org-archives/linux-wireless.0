Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:41474 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaEPNSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 09:18:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k:  improve vdev map handling.
References: <1398882179-17100-1-git-send-email-greearb@candelatech.com>
Date: Fri, 16 May 2014 16:18:11 +0300
In-Reply-To: <1398882179-17100-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 30 Apr 2014 11:22:59
	-0700")
Message-ID: <87fvk96ewc.fsf@kamboji.qca.qualcomm.com> (sfid-20140516_151820_972436_E5B3F0AE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Check vdev map has space before calling ffs,
> fix invalid cleanup in failure to create vdev
> case.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Why? What motivated you to write this? If you saw a bug, it would be
good to document the bug in the commit log.

> This is compile-tested only.

It's two weeks since you posted this, sorry for taking so long. But have
you managed to test this by now?

-- 
Kalle Valo
