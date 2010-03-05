Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44895 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0CEUYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 15:24:07 -0500
Received: by wya21 with SMTP id 21so2283890wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 12:24:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003052121.44331.IvDoorn@gmail.com>
References: <4B8E20CF.50109@users.sourceforge.net>
	 <201003051722.42437.IvDoorn@gmail.com>
	 <4B9165FE.1080502@users.sourceforge.net>
	 <201003052121.44331.IvDoorn@gmail.com>
Date: Fri, 5 Mar 2010 20:24:06 +0000
Message-ID: <efe7343f1003051224o4e0774f0v619fe4722e25ab89@mail.gmail.com>
Subject: Re: rt2870 (staging kernel driver) crashes fatally
From: Luis Correia <luis.f.correia@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "Daniele C." <legolas558@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well,

to set the record straight I did reply privately to tell that staging
isn't our business.

But my fault was not to point out the correct mailing list for staging.

I hope that my apology is accepted.
Luis Correia

On Fri, Mar 5, 2010 at 20:21, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Friday 05 March 2010, Daniele C. wrote:
>> -------- Original Message  --------
>> Subject: Re: rt2870 (staging kernel driver) crashes fatally
>> From: Ivo van Doorn <ivdoorn@gmail.com>
>> To: Larry Finger <Larry.Finger@lwfinger.net>
>> Date: Fri Mar 05 2010 17:22:41 GMT+0100 (CET)
>>
>> > On Thursday 04 March 2010, Larry Finger wrote:
>> >> On 03/03/2010 08:14 PM, Hin-Tak Leung wrote:
>> >>> You appear to have two issues - (1) the driver doesn't
>> >>> hibernate/resume well, (2) there is some bad memory leak which causes
>> >>> your system to run out of memory.
>> >>>
>> >>> You did not mention issue (1) - that you were hibernating and resuming
>> >>> (and expecting it to work, which it does not). For the latter, you
>> >>> probably need to track down where the memory is leaking in the driver,
>> >>> which is probably easier than tracking down the hibernate/resume
>> >>> issue.
>> >>>
>> >>> Good luck with tracking down the memory leak. (you do understand that
>> >>> staging drivers are DIY - i.e. you try it only if you are willing to
>> >>> look into fixing it yourself - I hope )
>> >>
>> >> By generating your own kernel with MEMLEAK enabled, you should be able to see
>> >> which data blob is being leaked. If you post that info, someone on this list
>> >> should be able to help you find the cause.
>> >
>> > Actually the rt2x00-users list is not intended for the Ralink staging drivers.
>> > You have to use the staging mailing list: devel@driverdev.osuosl.org
>> >
>> Yes, they refused my message but didn't tell anything about the staging mailing list which I couldn't find either and I am now reading from you. Many thanks for pointing this out.
>
> Your mail wasn't refused for the rt2x00-users mailinglist, we have a filter that prevents non-subscribed members from sending mails to it.
> Luis and myself are administrating the list, so your mails were approoved, but we forgot to press the button to allow all your mails
> to the list to be accepted. :)
>
>> I am now running with MEMLEAK enabled, as soon as I will make a new "hammering session" I'll grab the debug data and post another message.
>
> Good luck. :)
>
> Ivo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
