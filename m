Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16133 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaG1Tj3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 15:39:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k:  Improve 'hard' simulate fw crash.
References: <1406070004-6238-1-git-send-email-greearb@candelatech.com>
Date: Mon, 28 Jul 2014 22:39:20 +0300
In-Reply-To: <1406070004-6238-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 22 Jul 2014 16:00:04
	-0700")
Message-ID: <874my1l1cn.fsf@kamboji.qca.qualcomm.com> (sfid-20140728_213933_089474_7C7CEFE6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Different firmware may support different numbers of
> vdevs.  Use value that is always out of range for all
> firmware.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, applied.

-- 
Kalle Valo
