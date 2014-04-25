Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53438 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaDYJPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 05:15:37 -0400
Received: by mail-ob0-f170.google.com with SMTP id vb8so3954035obc.15
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 02:15:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535A12F3.8020003@gmail.com>
References: <5358AADD.3010702@gmail.com>
	<ljbdr0$c27$1@ger.gmane.org>
	<535A12F3.8020003@gmail.com>
Date: Fri, 25 Apr 2014 11:15:36 +0200
Message-ID: <CACna6rx+3CeucmhDDFwTii8A4KiEsTDQSeyTH6aLaYfs0YkaBg@mail.gmail.com> (sfid-20140425_111549_234308_ACE02A4E)
Subject: Re: Low 5 GHz performance of Intel Advanced-N 6230
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Julian Sikorski <belegdol@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-04-25 9:46 GMT+02:00 Emmanuel Grumbach <egrumbach@gmail.com>:
> On 04/24/2014 07:24 PM, Julian Sikorski wrote:
>> Is such a major performance hit expected from this change? Here is the
>> commit in question:
>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-3.13.y&id=45e5cb4f43d33e72ff5f98c80b081eb42e4e4182
>>
>
> Right - I disabled TX APMDU in this patch. This feature gives a big boost in TX performance, but lots of people experienced bugs that disappeared when this feature was disabled. This bug is in the firmware. Since the most common use case is to browse the internet which is more Rx than Tx, I decided to disabled this feature by default and allow people to enabled it using the module parameter.

Any plans to update (fix) the firmware?

-- 
Rafał
