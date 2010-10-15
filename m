Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:49295 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756163Ab0JOF6W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 01:58:22 -0400
Message-ID: <4CB7F7C7.7030804@gmx.net>
Date: Fri, 15 Oct 2010 08:42:15 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Compat-wireless N900
References: <4CB6BE57.8010401@gmx.net> <1287071844.11341.5.camel@gnutoo-laptop> <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com> <4CB74759.3030807@gmx.net> <AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>
In-Reply-To: <AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/10/2010 20:03, Luis R. Rodriguez wrote:
> On Thu, Oct 14, 2010 at 11:09 AM, George<george.news@gmx.net>  wrote:
>
>> I have tried using even insmod and the modules load perfectly but the wlan
>> device doesn't show up.
>
> Then that likely means you are not loading the right module.
>
>> In dmesg nothing is displayed except for the cfg80211 and when I rmmod the
>> module wl1251 (wl1251: removed or similar)
>>
>> I'm still wondering what the hell I have to do.
>
> Are you sure you have the right module?

Yes. The driver is the wl1251 family. As I said in previous posts and 
from what some guys in the IRC channel tried to guess, it seems that the 
problem might be in that the spi interface is specific for any device, 
and in the n900 might be different from the one implemented in 
compat-wireless.

I'm a bit suprised about this fact, but they know more than I.

TA

>    Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

