Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37033 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbcFWXu2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 19:50:28 -0400
Message-ID: <576C75BC.2030300@osg.samsung.com> (sfid-20160624_015047_655205_89B20736)
Date: Fri, 24 Jun 2016 00:50:20 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>,
	Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: wilc1000: arrays can't be NULL
References: <1466704629-26084-1-git-send-email-luisbg@osg.samsung.com> <1466709897.1847.24.camel@perches.com> <CAGRGNgVtQhFvn_LUjt-v8Kp+qHuxUaNAriS3UROAQfg725bQiQ@mail.gmail.com>
In-Reply-To: <CAGRGNgVtQhFvn_LUjt-v8Kp+qHuxUaNAriS3UROAQfg725bQiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24/06/16 00:15, Julian Calaby wrote:
> Hi Joe,
> 
> On Fri, Jun 24, 2016 at 5:24 AM, Joe Perches <joe@perches.com> wrote:
>> On Thu, 2016-06-23 at 18:57 +0100, Luis de Bethencourt wrote:
>>> hif_drv->usr_scan_req.net.net_info[i] contains found_net_info structs
>>> which have the following element:
>>> u8 bssid[6];
>> []
>>> I am aware this patch gives a few checkpatch.pl warnings about lines being
>>> over 80 characters. Fixing that would be a completely different issue, and
>>> a lengthy one since the file has loads of them.
>>>
>>> Hopefully somebody else picks that up. Maybe I should send a hit to the
>>> kernelnewbies mailing list :)
>>
>> Or not.
>>
>> really_long_identifiers™ makes using 80 columns silly.
>>
>> The hungarian could probably be converted though.
> 
> The main developers of this driver are slowly working through the
> driver's style issues, which is part of the reason why it's in
> staging.
> 
> Thanks,
> 

I understand Julian,

All the maintainers listed in the MAINTAINERS file are in CC. I will wait for
them to OK the suggestion of sending a patch fixing the Hungarian Notation.

Didn't mean to step on your toes. I just wanted to help.

Code in staging is cared for by a lot of people :)

Luis
