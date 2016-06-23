Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33903 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbcFWXzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 19:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <576C75BC.2030300@osg.samsung.com>
References: <1466704629-26084-1-git-send-email-luisbg@osg.samsung.com>
 <1466709897.1847.24.camel@perches.com> <CAGRGNgVtQhFvn_LUjt-v8Kp+qHuxUaNAriS3UROAQfg725bQiQ@mail.gmail.com>
 <576C75BC.2030300@osg.samsung.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 24 Jun 2016 09:54:48 +1000
Message-ID: <CAGRGNgWsih2VR5S56b4F_tji6KfU+_yUaTUQn_d0WEQ+7Ff_qw@mail.gmail.com> (sfid-20160624_015531_077796_0A5E4D57)
Subject: Re: [PATCH] staging: wilc1000: arrays can't be NULL
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Fri, Jun 24, 2016 at 9:50 AM, Luis de Bethencourt
<luisbg@osg.samsung.com> wrote:
> On 24/06/16 00:15, Julian Calaby wrote:
>> Hi Joe,
>>
>> On Fri, Jun 24, 2016 at 5:24 AM, Joe Perches <joe@perches.com> wrote:
>>> On Thu, 2016-06-23 at 18:57 +0100, Luis de Bethencourt wrote:
>>>> hif_drv->usr_scan_req.net.net_info[i] contains found_net_info structs
>>>> which have the following element:
>>>> u8 bssid[6];
>>> []
>>>> I am aware this patch gives a few checkpatch.pl warnings about lines being
>>>> over 80 characters. Fixing that would be a completely different issue, and
>>>> a lengthy one since the file has loads of them.
>>>>
>>>> Hopefully somebody else picks that up. Maybe I should send a hit to the
>>>> kernelnewbies mailing list :)
>>>
>>> Or not.
>>>
>>> really_long_identifiers™ makes using 80 columns silly.
>>>
>>> The hungarian could probably be converted though.
>>
>> The main developers of this driver are slowly working through the
>> driver's style issues, which is part of the reason why it's in
>> staging.
>>
>> Thanks,
>>
>
> I understand Julian,
>
> All the maintainers listed in the MAINTAINERS file are in CC. I will wait for
> them to OK the suggestion of sending a patch fixing the Hungarian Notation.

I was letting you know that this work is going to happen, not
dissuading you from doing it.

> Didn't mean to step on your toes. I just wanted to help.

No toes were stepped on. As I said, this was not a "don't do that"
message, this was an "it's going to happen eventually" message.

> Code in staging is cared for by a lot of people :)

Indeed it is.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
