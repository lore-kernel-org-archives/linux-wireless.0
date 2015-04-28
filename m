Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34991 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030253AbbD1Qki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 12:40:38 -0400
Received: by wgyo15 with SMTP id o15so472670wgy.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2015 09:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87383k5img.fsf@kamboji.qca.qualcomm.com>
References: <1424443813-13634-1-git-send-email-ap420073@gmail.com>
	<87383k5img.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 29 Apr 2015 01:40:36 +0900
Message-ID: <CAMArcTUuAK3cTf4L-Kp__Kmn3np2xRkfXKsOnY37M+00zzXPpg@mail.gmail.com> (sfid-20150428_184844_872589_339E7688)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix some beacon issue
From: Taehee Yoo <ap420073@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-04-29 1:21 GMT+09:00 Kalle Valo <kvalo@codeaurora.org>:
> Taehee Yoo <ap420073@gmail.com> writes:
>
>> Sometimes rtl8192cu is not sending beacon frame.
>> This patch fix this issue.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> Larry, what do you think? Should I apply this?
>
> https://patchwork.kernel.org/patch/5856761/
>
> --
> Kalle Valo



i think that it is incomplete patch.
because it can not solve Mike's problem.

Apologize about incomplete patch.
