Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32534 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaKXOTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:19:12 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 04/10] ath10k: make firmware text debug messages more verbose.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-4-git-send-email-greearb@candelatech.com>
Date: Mon, 24 Nov 2014 16:19:06 +0200
In-Reply-To: <1411507045-18973-4-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 23 Sep 2014 14:17:19
	-0700")
Message-ID: <87sih865r9.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_151915_858982_9E62BCE7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> There are not many of these messages producted by the
> firmware, but they are generally fairly useful, so print
> them at info level.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, applied. Though I did change the commit log:

commit 3be004c3aa4341c7c2461b37612a3a7a3323579d
Author: Ben Greear <greearb@candelatech.com>
Date:   Tue Sep 23 14:17:19 2014 -0700

    ath10k: add ATH10K_DBG_WMI_PRINT debug level
    
    There are not many of these messages producted by the
    firmware, but they are generally fairly useful, so make it easy to print them
    with a separate debug level.
    
    kvalo: fix commit log, rename debug level
    
    Signed-off-by: Ben Greear <greearb@candelatech.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
