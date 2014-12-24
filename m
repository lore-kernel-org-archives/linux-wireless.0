Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:53425 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaLXPfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 10:35:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: qca_vkondrat@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-next@vger.kernel.org
Subject: Re: [PATCH next] drivers/net/wireless/ath/wil6210/debugfs.c: Use 'uint64_t' instead of 'cycles_t' to avoid warnings
References: <549AD067.80608@gmail.com> <549AD54F.3020605@gmail.com>
	<8761d19j6z.fsf@kamboji.qca.qualcomm.com> <549ADA1D.8030509@gmail.com>
Date: Wed, 24 Dec 2014 17:35:07 +0200
In-Reply-To: <549ADA1D.8030509@gmail.com> (Chen Gang's message of "Wed, 24 Dec
	2014 23:22:05 +0800")
Message-ID: <87oaqt83is.fsf@kamboji.qca.qualcomm.com> (sfid-20141224_163521_037977_821B9D62)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chen Gang <gang.chen.5i5j@gmail.com> writes:

> On 12/24/2014 11:11 PM, Kalle Valo wrote:
>> Chen Gang <gang.chen.5i5j@gmail.com> writes:
>> 
>>> Oh, sorry, I forgot the word wrap (after change a new pc). I shall send
>>> patch v2 for it.
>> 
>> While at it, could you also please simplify the title. You don't have to
>> put the full directory there, it just makes it more difficult to read.
>> This should be enough:
>> 
>> wil6210: Use 'uint64_t' instead of 'cycles_t' to avoid warnings
>> 
>
> Oh, I have sent patch v2, if necessary, I will send patch v3 for it.
> (if necessary, please let me know)

I can edit it this time, but in the future please be use less verbose
titles.

-- 
Kalle Valo
