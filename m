Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:39153 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaIXLBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 07:01:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 3/3] ath10k: add cal_data debugfs file
References: <20140923143219.23585.34114.stgit@potku.adurom.net>
	<20140923143234.23585.2139.stgit@potku.adurom.net>
	<CA+BoTQ=O8j1x-71SCLq9ZiXBU28Ax9M7tyfbvB=mjsWUwgPSjw@mail.gmail.com>
Date: Wed, 24 Sep 2014 14:00:37 +0300
In-Reply-To: <CA+BoTQ=O8j1x-71SCLq9ZiXBU28Ax9M7tyfbvB=mjsWUwgPSjw@mail.gmail.com>
	(Michal Kazior's message of "Wed, 24 Sep 2014 09:00:39 +0200")
Message-ID: <87egv18eqy.fsf@kamboji.qca.qualcomm.com> (sfid-20140924_130110_074123_61B5D47E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 23 September 2014 16:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> [...]
>> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
>> index 101c6f9cf2a8..426341480262 100644
>> --- a/drivers/net/wireless/ath/ath10k/debug.c
>> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> [...]
>> +static int ath10k_cal_data_open(struct inode *inode, struct file *file)
>
> Shouldn't functions in debug.c have ath10k_debug_ prefix? I'm aware
> other fops stuff doesn't include the _debug word as well so this is
> somewhat consistent with the current code but is this okay in the
> grand scheme of things? Just wondering.

IMHO we should use ath10k_debug_ with fops functions as well, I just
haven't been that picky about that.

I'll change this as well and send v3. Thanks for review!

-- 
Kalle Valo
