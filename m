Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36051 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031166AbbD2Axw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 20:53:52 -0400
Received: by obbeb7 with SMTP id eb7so9383833obb.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2015 17:53:51 -0700 (PDT)
Message-ID: <55402B9C.5020607@lwfinger.net> (sfid-20150429_025716_972688_558E4843)
Date: Tue, 28 Apr 2015 19:53:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: Taehee Yoo <ap420073@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix some beacon issue
References: <1424443813-13634-1-git-send-email-ap420073@gmail.com>	<87383k5img.fsf@kamboji.qca.qualcomm.com> <CAMArcTUuAK3cTf4L-Kp__Kmn3np2xRkfXKsOnY37M+00zzXPpg@mail.gmail.com>
In-Reply-To: <CAMArcTUuAK3cTf4L-Kp__Kmn3np2xRkfXKsOnY37M+00zzXPpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/28/2015 11:40 AM, Taehee Yoo wrote:
> 2015-04-29 1:21 GMT+09:00 Kalle Valo <kvalo@codeaurora.org>:
>> Taehee Yoo <ap420073@gmail.com> writes:
>>
>>> Sometimes rtl8192cu is not sending beacon frame.
>>> This patch fix this issue.
>>>
>>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>>
>> Larry, what do you think? Should I apply this?
>>
>> https://patchwork.kernel.org/patch/5856761/
>>
>> --
>> Kalle Valo
>
>
>
> i think that it is incomplete patch.
> because it can not solve Mike's problem.
>
> Apologize about incomplete patch.

Kalle,

I have not been able to reproduce the problem, thus I could not comment as to 
whether the patch actually fixed anything.

Clearly, the patch should be dropped.

Thanks,

Larry


