Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38193 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbbI2IWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 04:22:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: use ether_addr_copy() instead of memcpy()
References: <87lhbylifx.fsf@kamboji.qca.qualcomm.com>
	<1442931866-17115-1-git-send-email-linux@rempel-privat.de>
	<22018.42528.871404.504088@gargle.gargle.HOWL>
	<5602D690.7000806@rempel-privat.de>
Date: Tue, 29 Sep 2015 11:22:17 +0300
In-Reply-To: <5602D690.7000806@rempel-privat.de> (Oleksij Rempel's message of
	"Wed, 23 Sep 2015 18:42:56 +0200")
Message-ID: <87vbat7hza.fsf@kamboji.qca.qualcomm.com> (sfid-20150929_102228_920007_22A25BAE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> Am 23.09.2015 um 15:16 schrieb Sujith Manoharan:
>> Oleksij Rempel wrote:
>>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |  2 +-
>>>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 24 ++++++++++++------------
>>>  2 files changed, 13 insertions(+), 13 deletions(-)
>> 
>> Both the arguments for ether_addr_copy() need to be
>> aligned. Is this the case for all the replacements in
>> this patch ?
>
> hm... you right. Kvalo, please drop this patch.

Dropped.

-- 
Kalle Valo
