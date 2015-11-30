Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8248 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbbK3JGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 04:06:06 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Brent Taylor <motobud@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: [PATCH v2] ath6kl: Use vmalloc for loading firmware using api1 method and use kvfree
References: <1444972259-24260-1-git-send-email-motobud@gmail.com>
	<1448774038-26984-1-git-send-email-motobud@gmail.com>
	<87zixvlvp8.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 30 Nov 2015 11:05:52 +0200
In-Reply-To: <87zixvlvp8.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 30 Nov 2015 10:48:03 +0200")
Message-ID: <87mvtvluvj.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_100615_568465_12CFD8CA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Brent Taylor <motobud@gmail.com> writes:
>
>> Signed-off-by: Brent Taylor <motobud@gmail.com>
>>
>> ath6kl: Use vmalloc for loading firmware using api1 method and free using kvfree
>> ---
>> Changes v1 -> v2:
>>    - simplify memory allocation
>>    - use kvfree
>
> Why? The commit log should _always_ answer that. Are you fixing a bug
> (what bug exactly?), is this just cleanup or what?
>
> And the commit log is wrongly formatted anyway, the Signed-off-by line
> should be the last and there should be no "ath6kl:" string in the commit
> log (just in the title). Use 'git log' to find examples.

Fixing netdev address (kenrel -> kernel)

-- 
Kalle Valo
