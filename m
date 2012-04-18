Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57295 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2DRPIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 11:08:31 -0400
Message-ID: <4F8ED8EA.5040506@lwfinger.net> (sfid-20120418_170848_930765_9C9A306D)
Date: Wed, 18 Apr 2012 10:08:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: oops on rmmod of rtl8192ce
References: <CAPM=9tz-2bXahnfDK0-anxyZcqFUPOSEewJxh2+2U51xypmw-w@mail.gmail.com> <CAPM=9tzqwZpWP9Ea-UVWYFcoVY-fa+jCf5FOShiMTrY4roN-og@mail.gmail.com> <4F83359B.90103@lwfinger.net> <CAPM=9txG+jzKUtnAfJ4dHUBY7fted0vs9WcteZ6aB+yWNdzLYw@mail.gmail.com>
In-Reply-To: <CAPM=9txG+jzKUtnAfJ4dHUBY7fted0vs9WcteZ6aB+yWNdzLYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2012 09:16 AM, Dave Airlie wrote:
> On Mon, Apr 9, 2012 at 8:16 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> On 04/09/2012 10:02 AM, Dave Airlie wrote:
>>>
>>> ping any ideas on this oops on unload?
>>
>>
>> Sorry about the delay.
>>
>> The oops looks like interrupts are not being disabled soon enough. Does the
>> following patch help?
>
> Seems to help here alright, I did a few load/unload cycles this
> morning on that laptop,
>
> I'll keep testing it for the situations I need it for, i.e. resume
> with wireless fail, which I haven't hit yet.

OK, I'll push the patch upstream. Will it be OK to use your name in Reported-by: 
and Tested-by: lines?

Larry

