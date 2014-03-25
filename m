Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31144 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaCYL7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 07:59:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4 v2] ath10k:  add debugging for tx-credits usage
References: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
Date: Tue, 25 Mar 2014 13:59:12 +0200
In-Reply-To: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 24 Mar 2014 12:20:40
	-0700")
Message-ID: <87y4zy1obz.fsf@kamboji.qca.qualcomm.com> (sfid-20140325_125938_989616_507850C5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This helps track tx credits accounting and usage.  If
> firmware hangs or otherwise fails to return credits, one
> can more easily see the last few command types that
> was sent to the firmware.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> v2:  Improve comments.  Issue of using __LINE__ is not resolved.

I'm going to drop this patch 1 for now, I'm not really fond of the idea
using line numbers in debug messages. Hopefully we find an alternative
solution, like what Michal proposed.

-- 
Kalle Valo
