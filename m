Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12163 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbbCWPR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 11:17:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] ath10k: thermal mitigation fixes
References: <1426431985-16332-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 23 Mar 2015 17:17:49 +0200
In-Reply-To: <1426431985-16332-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Sun, 15 Mar 2015 20:36:19 +0530")
Message-ID: <877fu7eo9u.fsf@kamboji.qca.qualcomm.com> (sfid-20150323_161804_896219_E130B336)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Here are few enhancements in thermal throttling that allows
> user to control throttling state and quiet period. Also enables
> throttling for station mode. These patches are rebased on latest TOT.
>
> Rajkumar Manoharan (6):
>   ath10k: add debugfs entry to configure quiet period
>   ath10k: Fix interpretation of cooling device state
>   ath10k: configure thermal throttle while powering up
>   ath10k: do not restrict thermal throttling to ap mode
>   ath10k: cache throttle state when device is down
>   ath10k: move driver state check before setting throttle

Thanks, applied.

-- 
Kalle Valo
