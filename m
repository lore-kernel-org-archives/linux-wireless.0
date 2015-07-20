Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42427 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbbGTPsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 11:48:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, mickflemm@gmail.com,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath9k: spectral - simplify max_index calculation
References: <1434626241-1334-1-git-send-email-zefir.kurtisi@neratec.com>
	<5582E0CF.1050804@neratec.com>
Date: Mon, 20 Jul 2015 18:48:08 +0300
In-Reply-To: <5582E0CF.1050804@neratec.com> (Zefir Kurtisi's message of "Thu,
	18 Jun 2015 17:16:31 +0200")
Message-ID: <877fpusudj.fsf@kamboji.qca.qualcomm.com> (sfid-20150720_174817_396618_866D2600)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:

> After further discussion with Nick, we better leave spectral as is.
>
> Please ignore / drop this one.

Ok, patch dropped.

> On 06/18/2015 01:17 PM, Zefir Kurtisi wrote:
>> The max_index value provided in the spectral data set
>> has to be interpreted differently for HT20 and HT40.
>> In HT40, the value is given as unsigned index and
>> shall be taken as is, while in HT20 it is a signed
>> value around bin index 28 and needs to be converted
>> to an unsigned index.
>> 
>> This patch simplifies the previous correction and
>> prepares the related functions to be shared with
>> the DFS module.
>> 
>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Please edit your quotes, leaving this extra cruft makes it hard for me
to use patchwork.

-- 
Kalle Valo
