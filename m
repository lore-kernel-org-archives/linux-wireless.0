Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7743 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbGXHsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 03:48:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Maninder Singh <maninder1.s@samsung.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<pankaj.m@samsung.com>
Subject: Re: [PATCH 1/1] ath10k: fixing wrong initialization of struct channel
References: <1437018933-25832-1-git-send-email-maninder1.s@samsung.com>
Date: Fri, 24 Jul 2015 10:48:14 +0300
In-Reply-To: <1437018933-25832-1-git-send-email-maninder1.s@samsung.com>
	(Maninder Singh's message of "Thu, 16 Jul 2015 09:25:33 +0530")
Message-ID: <87mvymf135.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_094825_555715_022A9046)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maninder Singh <maninder1.s@samsung.com> writes:

> chandef is initialized with NULL and on the very next line,
> we are using it to get channel, which is not correct.
>
> channel should be initialized after obtaining chandef.
>
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>

Thanks, applied.

-- 
Kalle Valo
