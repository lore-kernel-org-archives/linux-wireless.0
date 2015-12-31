Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:29269 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbbLaNOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 08:14:49 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: wake up device before accessing registers
References: <1449740667-25901-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 31 Dec 2015 15:14:32 +0200
In-Reply-To: <1449740667-25901-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 10 Dec 2015 15:14:26 +0530")
Message-ID: <8760zeoj47.fsf@kamboji.qca.qualcomm.com> (sfid-20151231_141452_803633_B55F37A5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> commit 1aaf8efba0ae ("ath10k: disable PCI PS for QCA988X
> and QCA99X0") partially reverts pci soc powersave support added by
> commit 77258d409ce4 ("ath10k: enable pci soc powersaving"). While
> reverting the change, pci wake up function is called after accessing
> pci registers instead of prior to access. The assumption is that chip
> is woken up before accessing its registers.Though this change does not
> fix any known issues, this might help to avoid unknown or low power
> platform specific issues.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Both patches applied, thanks.

-- 
Kalle Valo
