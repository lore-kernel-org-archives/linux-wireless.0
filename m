Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20528 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaIWJdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 05:33:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/9] ath10k: mostly cleanups
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 23 Sep 2014 12:33:04 +0300
In-Reply-To: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 18 Sep 2014 15:21:18 +0200")
Message-ID: <87tx3yel67.fsf@kamboji.qca.qualcomm.com> (sfid-20140923_113327_325774_CFA6C494)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Here's a bunch of clean up patches for WMI and a
> single fix. I'm including the fix in this patchset
> because one of the clean up patches depends on it.
>
>
> Michal Kazior (9):
>   ath10k: fix tx/rx chainmask init
>   ath10k: remove unused pdev_set_channel command
>   ath10k: deduplicate wmi_channel code
>   ath10k: deduplicate host mem chunk code
>   ath10k: relocate wmi attach/deatch functions
>   ath10k: deduplicate wmi service ready logic
>   ath10k: clean up phyerr code
>   ath10k: unify wmi event function names
>   ath10k: re-work scan start command building

Thanks, all nine patches applied.

-- 
Kalle Valo
