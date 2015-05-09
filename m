Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35281 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbbEISM2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 14:12:28 -0400
Received: by widdi4 with SMTP id di4so63276725wid.0
        for <linux-wireless@vger.kernel.org>; Sat, 09 May 2015 11:12:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87h9rmnem1.fsf@kamboji.qca.qualcomm.com>
References: <1430841518-3932-1-git-send-email-ap420073@gmail.com>
	<87pp6bp6jy.fsf@kamboji.qca.qualcomm.com>
	<CAMArcTW2qRiM4dVJQDDXJSuLEn6-GGJD4PJBTfhDDDOs+MxRrQ@mail.gmail.com>
	<87h9rmnem1.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 10 May 2015 03:12:26 +0900
Message-ID: <CAMArcTWw2UBr+_jAOFFi2OFBtbw2RHHEnrzL=7y10ZpO8Pk40w@mail.gmail.com> (sfid-20150509_202132_097589_85ADB185)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Modify REG_BCN_MAX_ERR related code.
From: Taehee Yoo <ap420073@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-05-09 21:02 GMT+09:00 Kalle Valo <kvalo@codeaurora.org>:
> Taehee Yoo <ap420073@gmail.com> writes:
>
>> 2015-05-08 22:01 GMT+09:00 Kalle Valo <kvalo@codeaurora.org>:
>>> Taehee Yoo <ap420073@gmail.com> writes:
>>>
>>>> 1. Remove setting REG_BCN_MAX_ERR code in _rtl92cu_set_media_status().
>>>> Initialization routine set REG_BCN_MAX_ERR to 0xFF.
>>>> also _rtl92cu_set_media_status set REG_BCN_MAX_ERR to same value.
>>>> so i remove this code.
>>>>
>>>> 2. Remove rtl92c_init_beacon_max_error's parameter.
>>>> because parameter "infra_mode" is not used.
>>>>
>>>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>>>
>>> Please split the patches into two. Having a numbered list of changes in
>>> the commit log is a strong indication that the patch should be split
>>> into smaller patches.
>>>
>>> --
>>> Kalle Valo
>>
>> Thank you for your review!
>> I'll resend two patchs.
>
> Thanks. But when you send new versions please mark them as v2, v3 and so
> on as that makes it easy for me to see what is the latest version.
>
> --
> Kalle Valo


I already sent two patchs as "rtlwifi: rtl8192cu: Remove setting
REG_BCN_MAX_ERR code in _rtl92cu_set_media_status()." and "rtlwifi:
rtl8192cu: Remove rtl92c_init_beacon_max_error's parameter"

is it right? or would I resend as V2?
