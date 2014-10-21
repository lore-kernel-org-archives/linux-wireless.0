Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52630 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaJUHw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 03:52:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: use bss_info as txpower source
References: <1412940780-25360-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 21 Oct 2014 10:52:51 +0300
In-Reply-To: <1412940780-25360-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Oct 2014 13:33:00 +0200")
Message-ID: <87ppdlyi3w.fsf@kamboji.qca.qualcomm.com> (sfid-20141021_095305_428865_32ADAF75)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This simply changes the source for txpower setup.
> It does not make ath10k use different txpower
> values for different vifs.
>
> This will make it easier to implement chanctx in
> ath10k in the future.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
