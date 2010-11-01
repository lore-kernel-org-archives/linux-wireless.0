Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45963 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab0KAVWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 17:22:05 -0400
Received: by ywc21 with SMTP id 21so1187367ywc.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 14:22:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=jyGZ+LLZ2cDiF7CFC1h_WbzwmOOLQkSpOaLAz@mail.gmail.com>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
 <1288181398-2358-2-git-send-email-eliad@wizery.com> <1288617893.20937.10.camel@chilepepper>
 <AANLkTi=jyGZ+LLZ2cDiF7CFC1h_WbzwmOOLQkSpOaLAz@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 1 Nov 2010 22:21:42 +0100
Message-ID: <AANLkTin+RQ8zjbQKFcZJjoVcT=GkuMYTYEbt47TFuAC6@mail.gmail.com>
Subject: Re: [PATCH 2/2] wl1271: add recover testmode command
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 1, 2010 at 9:59 PM, Eliad Peller <eliad@wizery.com> wrote:
>>> add RECOVER testmode command.
>>> this command triggers a recovery sequence (by enqueueing a recovery_work).
>>>
>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>> ---
>>
>> So, the point of this patch is to allow hardware recovery from the
>> userspace? In what kind of scenario do you need this?
>>
>
> yes.
> it's mainly for testing (or if we want to recover manually for some reason).
> this is why i implemented it as a testmode command.

Isn't testmode for features used during regulatory testing, that the
user should be unable to access to ensure further regulatory
compliance?

>
> i added it after observing some recovery issues (until applying
> Juuso's "wl1271: Check interface state in op_* functions" :) )
>
> Eliad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
