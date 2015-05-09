Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50711 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbEIMCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 08:02:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Modify REG_BCN_MAX_ERR related code.
References: <1430841518-3932-1-git-send-email-ap420073@gmail.com>
	<87pp6bp6jy.fsf@kamboji.qca.qualcomm.com>
	<CAMArcTW2qRiM4dVJQDDXJSuLEn6-GGJD4PJBTfhDDDOs+MxRrQ@mail.gmail.com>
Date: Sat, 09 May 2015 15:02:14 +0300
In-Reply-To: <CAMArcTW2qRiM4dVJQDDXJSuLEn6-GGJD4PJBTfhDDDOs+MxRrQ@mail.gmail.com>
	(Taehee Yoo's message of "Sat, 9 May 2015 18:11:45 +0900")
Message-ID: <87h9rmnem1.fsf@kamboji.qca.qualcomm.com> (sfid-20150509_140225_648796_EBBEFD3F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taehee Yoo <ap420073@gmail.com> writes:

> 2015-05-08 22:01 GMT+09:00 Kalle Valo <kvalo@codeaurora.org>:
>> Taehee Yoo <ap420073@gmail.com> writes:
>>
>>> 1. Remove setting REG_BCN_MAX_ERR code in _rtl92cu_set_media_status().
>>> Initialization routine set REG_BCN_MAX_ERR to 0xFF.
>>> also _rtl92cu_set_media_status set REG_BCN_MAX_ERR to same value.
>>> so i remove this code.
>>>
>>> 2. Remove rtl92c_init_beacon_max_error's parameter.
>>> because parameter "infra_mode" is not used.
>>>
>>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>>
>> Please split the patches into two. Having a numbered list of changes in
>> the commit log is a strong indication that the patch should be split
>> into smaller patches.
>>
>> --
>> Kalle Valo
>
> Thank you for your review!
> I'll resend two patchs.

Thanks. But when you send new versions please mark them as v2, v3 and so
on as that makes it easy for me to see what is the latest version.

-- 
Kalle Valo
