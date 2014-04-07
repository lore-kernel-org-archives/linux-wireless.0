Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16067 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaDGNwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 09:52:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: reorder functions
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-2-git-send-email-michal.kazior@tieto.com>
Date: Mon, 7 Apr 2014 16:52:26 +0300
In-Reply-To: <1396610926-5787-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Apr 2014 13:28:45 +0200")
Message-ID: <87fvlpnt5x.fsf@kamboji.qca.qualcomm.com> (sfid-20140407_155235_261418_68DA7244)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This is done to avoid forward declarations with
> upcomming patches.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Like you said, I had a conflict with this patch. Can you double check my
resolution, please:

https://github.com/kvalo/ath/commit/0953accf20c325adde537a57c3e6a6a0f1ff04d7

-- 
Kalle Valo
