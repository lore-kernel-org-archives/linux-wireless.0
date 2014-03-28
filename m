Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1478 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaC1MrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 08:47:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
Date: Fri, 28 Mar 2014 14:47:01 +0200
In-Reply-To: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Tue, 25 Mar 2014 15:55:46 +0800")
Message-ID: <871txmwkvu.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_134712_569127_B978DB73)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> This patch is intended to fix the problem if we use the
> firmware 999.999.0.636 to get peer stats when the number
> of peer is more than 3. The WMI_UPDATE_STATS_EVENTID may
> trigger more than 1 time if the number of peers is more
> than 3. So this patch allows us to do the checking on this
> and make sure that we print the peer stats correctly.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Based on Michal's comments I'm going to drop this one, we need to find a
better way to solve this.

-- 
Kalle Valo
