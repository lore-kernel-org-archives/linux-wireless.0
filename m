Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8885 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbbLGRwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 12:52:01 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"Vivek Natarajan" <nataraja@qti.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with Linus' tree
References: <20151207141325.1609aec1@canb.auug.org.au>
	<87r3iycnj4.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 7 Dec 2015 19:51:35 +0200
In-Reply-To: <87r3iycnj4.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 07 Dec 2015 16:59:43 +0200")
Message-ID: <874mfucfko.fsf@kamboji.qca.qualcomm.com> (sfid-20151207_185224_589599_7E224845)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>
>> Today's linux-next merge of the wireless-drivers-next tree got a
>> conflict in:
>>
>>   drivers/net/wireless/ath/ath10k/pci.c
>>
>> between commit:
>>
>>   6419fdbb6f90 ("ath10k: poll HTT send completion when CE 5 is unused")
>>
>> from Linus' tree and commit:
>>
>>   afb0bf7f530b ("ath10k: add support for pktlog in QCA99X0")
>>
>> from the wireless-drivers-next tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>
> Thanks, the fix looks good to me.

BTW, this conflict should be fixed once Dave merges my
wireless-drivers-next pull request.

-- 
Kalle Valo
