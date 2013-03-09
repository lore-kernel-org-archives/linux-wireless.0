Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64451 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3CIGVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 01:21:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: <nick@nhthomas.freeserve.co.uk>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl build error.
References: <19954030.22961362741929700.JavaMail.www@wwinf3707>
	<513A3075.5040100@lwfinger.net>
Date: Sat, 9 Mar 2013 08:21:45 +0200
In-Reply-To: <513A3075.5040100@lwfinger.net> (Larry Finger's message of "Fri,
	08 Mar 2013 12:39:49 -0600")
Message-ID: <87a9qdm6ti.fsf@kamboji.qca.qualcomm.com> (sfid-20130309_072205_813566_51FDBDB0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 03/08/2013 05:25 AM, nick@nhthomas.freeserve.co.uk wrote:
>>
>> I'm getting a build error when building ath6kl modules.
>>
>> include/linux/mmc/sdio_func.h:162:12: error: expected identifier or '(' before numeric constant
>>
>> the line it's complaining about is like this:
>>
>> extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
>>
>>
>> A bit of googling has shown that others have seen the same problem too.
>> But, I've not seen a fix for it.
>>
>> Any ideas appreciated.
>
> The complete gcc error output would be helpful.
>
> What kernel are you using?

I think he's using compat-driver and compiling against some old vendor
kernel.

-- 
Kalle Valo
