Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65498 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab3IEOcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 10:32:15 -0400
Received: from [192.168.2.102] ([79.218.101.214]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0MNZVG-1VKKhD3edW-007F9E for
 <linux-wireless@vger.kernel.org>; Thu, 05 Sep 2013 16:32:13 +0200
Message-ID: <522895ED.2080403@rempel-privat.de> (sfid-20130905_163218_389356_B4DEBD8F)
Date: Thu, 05 Sep 2013 16:32:13 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Antonio Quartulli <ordex@autistici.org>
CC: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: WARNING with ath9k_htc on TL-WN721N
References: <20130905100914.GA1570@ritirata.org> <52285C02.8050205@rempel-privat.de> <20130905103204.GB1570@ritirata.org> <52289033.8080205@rempel-privat.de> <52289080.80604@rempel-privat.de> <20130905142122.GE1570@ritirata.org>
In-Reply-To: <20130905142122.GE1570@ritirata.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 05.09.2013 16:21, schrieb Antonio Quartulli:
> On Thu, Sep 05, 2013 at 04:09:04PM +0200, Oleksij Rempel wrote:
>> Forgot attachment.
>>
>>
>> Am 05.09.2013 16:07, schrieb Oleksij Rempel:
>>> Hi,
>>>
>>> thank you.
>>>
>>> please do some tests for me.
>>>
>>> 1. run wireless adapter without other devices on this bus.
>>>
>
> Ok Oleksij, I'll try to do these tests soonish. You think the problem is
> triggered by a scan operation?
>
> If so, I'll try to reproduce it by scanning. Till now I had no clue about the
> cause.

Probably no only scan. Normally if you use network manager, it will scan 
each 160 seconds or so. In this case you will get this warning lot more 
often. Probably it comes together: hight network traffic + channel scan 
+ usb traffic of other devices on same bus.


-- 
Regards,
Oleksij
