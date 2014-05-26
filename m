Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5249 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaEZJni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:43:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <yeohchunyeow@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix protected flag stripping
References: <1400498110-12879-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 26 May 2014 12:43:29 +0300
In-Reply-To: <1400498110-12879-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 19 May 2014 13:15:10 +0200")
Message-ID: <87tx8cswn2.fsf@kamboji.qca.qualcomm.com> (sfid-20140526_114350_337145_407DE314)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This prevents protected flag being stripped from
> undecrypted raw sniffed frames when monitor
> interface is active.
>
> Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
