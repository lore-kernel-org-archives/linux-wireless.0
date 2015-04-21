Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57666 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbbDURim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 13:38:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix qca61x4 hw2.1 support
References: <1429521641-21993-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 21 Apr 2015 20:38:30 +0300
In-Reply-To: <1429521641-21993-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 20 Apr 2015 09:20:41 +0000")
Message-ID: <87bnihz8ix.fsf@kamboji.qca.qualcomm.com> (sfid-20150421_193846_355476_459761F2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> During initialization firmware does some sort of
> memory switch between DRAM and IRAM. If
> configuration value for bank switching isn't
> correct device crashes during init.
>
> The new value prevents firmware 11.0.0.302 (and
> possibly others) for qca61x4 hw2.1 from crashing
> during init.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
