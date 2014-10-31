Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8082 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422646AbaJaAaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 20:30:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] ath10k: pci related fixes 2014-10-09
References: <1414488728-31489-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 31 Oct 2014 02:29:51 +0200
In-Reply-To: <1414488728-31489-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 28 Oct 2014 10:32:04 +0100")
Message-ID: <87lhnxdqtc.fsf@kamboji.qca.qualcomm.com> (sfid-20141031_013021_370735_6ECF344A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This is a partial re-spin which includes the
> not-yet-applied patches that fix/change warm
> reset.
>
> v3:
>  * change CE ring cleanup (new patch #1)
>
>
> Michal Kazior (4):
>   ath10k: change ce ring cleanup logic
>   ath10k: make warm reset a bit safer and faster
>   ath10k: split reset logic from power up
>   ath10k: don't reset chip on power_down

Thanks, all four patches applied.

-- 
Kalle Valo
