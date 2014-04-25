Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52362 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaDYW1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 18:27:44 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so3169371eek.4
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 15:27:43 -0700 (PDT)
Received: from [192.168.1.2] (46-126-92-137.dynamic.hispeed.ch. [46.126.92.137])
        by mx.google.com with ESMTPSA id o7sm28203914eew.25.2014.04.25.15.27.41
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 25 Apr 2014 15:27:42 -0700 (PDT)
Message-ID: <535AE15D.8010704@gmail.com> (sfid-20140426_002748_184952_051FDA8C)
Date: Sat, 26 Apr 2014 00:27:41 +0200
From: Julian Sikorski <belegdol@gmail.com>
MIME-Version: 1.0
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Low 5 GHz performance of Intel Advanced-N 6230
References: <5358AADD.3010702@gmail.com>	<ljbdr0$c27$1@ger.gmane.org>	<535A12F3.8020003@gmail.com> <CACna6rx+3CeucmhDDFwTii8A4KiEsTDQSeyTH6aLaYfs0YkaBg@mail.gmail.com> <535A3021.8070003@gmail.com>
In-Reply-To: <535A3021.8070003@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 25.04.2014 11:51, Emmanuel Grumbach pisze:
> 
> 
> On 04/25/2014 12:15 PM, Rafał Miłecki wrote:
>> 2014-04-25 9:46 GMT+02:00 Emmanuel Grumbach <egrumbach@gmail.com>:
>>> On 04/24/2014 07:24 PM, Julian Sikorski wrote:
>>>> Is such a major performance hit expected from this change? Here is the
>>>> commit in question:
>>>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-3.13.y&id=45e5cb4f43d33e72ff5f98c80b081eb42e4e4182
>>>>
>>>
>>> Right - I disabled TX APMDU in this patch. This feature gives a big boost in TX performance, but lots of people experienced bugs that disappeared when this feature was disabled. This bug is in the firmware. Since the most common use case is to browse the internet which is more Rx than Tx, I decided to disabled this feature by default and allow people to enabled it using the module parameter.
>>
>> Any plans to update (fix) the firmware?
>>
> 
> I don't work on the firmware level, so I can't really say, but I doubt someone will have the cycles to fix the firmware for these devices. Newer devices (7260 and up) have this feature enabled.
> 
Can this feature be disabled on a per-device basis? It clearly works for
6230 and is a huge performance hit when gone.

Julian
