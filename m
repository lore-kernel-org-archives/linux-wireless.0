Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34486 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcFWXPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 19:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <1466709897.1847.24.camel@perches.com>
References: <1466704629-26084-1-git-send-email-luisbg@osg.samsung.com> <1466709897.1847.24.camel@perches.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 24 Jun 2016 09:15:02 +1000
Message-ID: <CAGRGNgVtQhFvn_LUjt-v8Kp+qHuxUaNAriS3UROAQfg725bQiQ@mail.gmail.com> (sfid-20160624_011556_062608_705BD688)
Subject: Re: [PATCH] staging: wilc1000: arrays can't be NULL
To: Joe Perches <joe@perches.com>
Cc: Luis de Bethencourt <luisbg@osg.samsung.com>,
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

Hi Joe,

On Fri, Jun 24, 2016 at 5:24 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2016-06-23 at 18:57 +0100, Luis de Bethencourt wrote:
>> hif_drv->usr_scan_req.net.net_info[i] contains found_net_info structs
>> which have the following element:
>> u8 bssid[6];
> []
>> I am aware this patch gives a few checkpatch.pl warnings about lines being
>> over 80 characters. Fixing that would be a completely different issue, and
>> a lengthy one since the file has loads of them.
>>
>> Hopefully somebody else picks that up. Maybe I should send a hit to the
>> kernelnewbies mailing list :)
>
> Or not.
>
> really_long_identifiers™ makes using 80 columns silly.
>
> The hungarian could probably be converted though.

The main developers of this driver are slowly working through the
driver's style issues, which is part of the reason why it's in
staging.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
