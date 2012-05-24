Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gretel.risen.be ([78.46.99.137]:48248 "EHLO gretel.risen.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab2EXCpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 22:45:43 -0400
Message-ID: <4FBDA0A9.4020303@aquazul.com> (sfid-20120524_044547_894529_07DF6297)
Date: Thu, 24 May 2012 04:44:57 +0200
From: Mourad De Clerck <bugs-wireless@aquazul.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails for b43 using linux 3.4?
References: <4FBD7772.6070305@aquazul.com> <4FBD8B42.5020708@lwfinger.net>
In-Reply-To: <4FBD8B42.5020708@lwfinger.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24/05/12 03:13, Larry Finger wrote:
>> The only obvious change is 6b6fa5868eec26bdc6a83543cebb8cf832a2645a
>> by Larry Finger. I don't know if it matters, but b43 is statically
>> compiled in the kernel.
>>
>> Am I missing something?
>
> I do not know. I am building a system with b43 built in. Have you tried
> using b43 as a module?

I just did – exact same config, just b43 as a module. And indeed, now 
the firmware loads fine.

I suppose this isn't intentional… this was working in 3.3, btw.

Thanks,

-- Mourad DC
