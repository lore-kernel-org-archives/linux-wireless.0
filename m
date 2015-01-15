Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27854 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbAOKe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 05:34:26 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix duration calculation for quiet param
References: <1421140934-16109-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 15 Jan 2015 12:34:16 +0200
In-Reply-To: <1421140934-16109-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 13 Jan 2015 14:52:14 +0530")
Message-ID: <871tmwz61j.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_113430_060893_4C32A297)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> The duty cycle (% of quiet duration) is used to put the device
> in quiet mode for the given period. Currently the quiet duration
> is wrongly calculated which results in not enabling quiet mode.
> Fix the calculation as below
>
>      duration = (period * duty cycle) / 100
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
