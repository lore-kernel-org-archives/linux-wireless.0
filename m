Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:17603 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbbEPLPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 07:15:46 -0400
Message-ID: <555726DF.6060505@broadcom.com> (sfid-20150516_131550_172146_BB7CF11D)
Date: Sat, 16 May 2015 13:15:43 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: Arend van Spriel <aspriel@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: new release of py80211 - v1.0-alpha
References: <55563D20.9030702@gmail.com> <1431717445.7716.4.camel@coelho.fi>
In-Reply-To: <1431717445.7716.4.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/15 21:17, Luca Coelho wrote:
> On Fri, 2015-05-15 at 20:38 +0200, Arend van Spriel wrote:
>> Recently got triggered by Luca and with some free time to spare extended
>> the functionality in py80211. It is still mostly about retrieving
>> information although it also supports scanning now dealing with
>> notifications from the scan multicast group. It has been a fun week
>> puzzling on some hurdles. Hopefully I can keep spending more time on
>> this personal project and keep momentum.
>>
>> The project can be found on github and the release notes are here [1].
>
> This is very cool! I was trying your updates for scanning today and it
> works great! I already started converting my test modules to use it.
>
> I know the hurdles you were talking about, I had gone through a few of
> them, but I was just hacking through, with much less class. ;)
>
> I hope I'll be able to start contributing to your project in the near
> future.
>
> Big thanks for getting momentum from my quick query about the state of
> the your project. :)

Thanks, Luca

I wrote a couple of wiki pages on github about adding stuff to py80211 
package. I started this project with automated testing in mind so I can 
ultimately replace our current testing stuff, which is focused on the 
prorietary drivers using ioctl-based wl utility, with one using the 
nl80211 api.

Regards,
Arend

> --
> Luca.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

