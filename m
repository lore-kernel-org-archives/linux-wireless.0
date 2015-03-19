Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30018 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbCSIrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 04:47:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: enable ANI by default
References: <1426701700-21974-1-git-send-email-arnagara@qti.qualcomm.com>
	<874mphl6jc.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 19 Mar 2015 10:47:22 +0200
In-Reply-To: <874mphl6jc.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Thu, 19 Mar 2015 10:45:27 +0200")
Message-ID: <87zj79jrvp.fsf@kamboji.qca.qualcomm.com> (sfid-20150319_094736_136367_0FAF2CBD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> writes:
>
>> ANI is currently not enabled by default. Enable this feature by default.
>>
>> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
>
> You did not send this to ath10k list (and CC linux-wireless). Check the
> instructions here:
>
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/sources#submitting_patches
>
> Also the commit log doesn't tell anything. What is ANI and why should it
> be enabled? What bug does this fix (if any)? How will the user see the
> difference after this patch is applied?
>
> As a rule of thumb, the commit log should tell any engineer (even one
> who is not familiar with ath10k) how the behaviour changes after the
> patch is applied. Think of your target group being distro maintainers,
> ath10k users, kernel subsystem maintainers etc. No company internal
> jargon or anything like that, write in plain english so that everyone
> understand.

I also forgot to CC ath10k list.

-- 
Kalle Valo
