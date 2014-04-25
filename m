Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50901 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDYJvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 05:51:32 -0400
Received: by mail-wg0-f42.google.com with SMTP id k14so712271wgh.13
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 02:51:31 -0700 (PDT)
Message-ID: <535A3021.8070003@gmail.com> (sfid-20140425_115137_558216_44C97868)
Date: Fri, 25 Apr 2014 12:51:29 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Julian Sikorski <belegdol@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Low 5 GHz performance of Intel Advanced-N 6230
References: <5358AADD.3010702@gmail.com>	<ljbdr0$c27$1@ger.gmane.org>	<535A12F3.8020003@gmail.com> <CACna6rx+3CeucmhDDFwTii8A4KiEsTDQSeyTH6aLaYfs0YkaBg@mail.gmail.com>
In-Reply-To: <CACna6rx+3CeucmhDDFwTii8A4KiEsTDQSeyTH6aLaYfs0YkaBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/25/2014 12:15 PM, Rafał Miłecki wrote:
> 2014-04-25 9:46 GMT+02:00 Emmanuel Grumbach <egrumbach@gmail.com>:
>> On 04/24/2014 07:24 PM, Julian Sikorski wrote:
>>> Is such a major performance hit expected from this change? Here is the
>>> commit in question:
>>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-3.13.y&id=45e5cb4f43d33e72ff5f98c80b081eb42e4e4182
>>>
>>
>> Right - I disabled TX APMDU in this patch. This feature gives a big boost in TX performance, but lots of people experienced bugs that disappeared when this feature was disabled. This bug is in the firmware. Since the most common use case is to browse the internet which is more Rx than Tx, I decided to disabled this feature by default and allow people to enabled it using the module parameter.
> 
> Any plans to update (fix) the firmware?
> 

I don't work on the firmware level, so I can't really say, but I doubt someone will have the cycles to fix the firmware for these devices. Newer devices (7260 and up) have this feature enabled.
