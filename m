Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42561 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbEKGjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 02:39:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Modify REG_BCN_MAX_ERR related code.
References: <1430841518-3932-1-git-send-email-ap420073@gmail.com>
	<87pp6bp6jy.fsf@kamboji.qca.qualcomm.com>
	<CAMArcTW2qRiM4dVJQDDXJSuLEn6-GGJD4PJBTfhDDDOs+MxRrQ@mail.gmail.com>
	<87h9rmnem1.fsf@kamboji.qca.qualcomm.com>
	<CAMArcTWw2UBr+_jAOFFi2OFBtbw2RHHEnrzL=7y10ZpO8Pk40w@mail.gmail.com>
Date: Mon, 11 May 2015 09:39:28 +0300
In-Reply-To: <CAMArcTWw2UBr+_jAOFFi2OFBtbw2RHHEnrzL=7y10ZpO8Pk40w@mail.gmail.com>
	(Taehee Yoo's message of "Sun, 10 May 2015 03:12:26 +0900")
Message-ID: <877fsflisf.fsf@kamboji.qca.qualcomm.com> (sfid-20150511_083938_645492_1AF8B431)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taehee Yoo <ap420073@gmail.com> writes:

>>> Thank you for your review!
>>> I'll resend two patchs.
>>
>> Thanks. But when you send new versions please mark them as v2, v3 and so
>> on as that makes it easy for me to see what is the latest version.
>
> I already sent two patchs as "rtlwifi: rtl8192cu: Remove setting
> REG_BCN_MAX_ERR code in _rtl92cu_set_media_status()." and "rtlwifi:
> rtl8192cu: Remove rtl92c_init_beacon_max_error's parameter"
>
> is it right? or would I resend as V2?

No need to resend this time, but in the future please always increase
the version when changing patches.

-- 
Kalle Valo
