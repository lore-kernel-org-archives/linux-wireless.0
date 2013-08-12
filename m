Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6839 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab3HLOrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 10:47:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: cleanups
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
	<87haevt20x.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 12 Aug 2013 17:47:33 +0300
In-Reply-To: <87haevt20x.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 12 Aug 2013 17:30:22 +0300")
Message-ID: <87d2pjt18a.fsf@kamboji.qca.qualcomm.com> (sfid-20130812_164744_056542_FEA560E5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This patchset contains a few non-functional clean
>> ups.
>>
>> Michal Kazior (4):
>>   ath10k: clean up monitor start code
>>   ath10k: use sizeof(*var) in kmalloc
>>   ath10k: clean up PCI completion states
>>   ath10k: print errcode when CE ring setup fails
>
> Thanks, all four applied.

Sorry, I was too fast and need to take that back. I now see this
warning:

drivers/net/wireless/ath/ath10k/pci.c:951: WARNING: line over 80 characters

I dropped the patches, please send v2.

-- 
Kalle Valo
