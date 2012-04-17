Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40659 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2DQT2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 15:28:03 -0400
Received: by obbta14 with SMTP id ta14so5514874obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 12:28:02 -0700 (PDT)
Message-ID: <4F8DC439.103@lwfinger.net> (sfid-20120417_212807_723740_378F3BA2)
Date: Tue, 17 Apr 2012 14:27:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: carl9170 firmware
References: <4F8DA785.6040608@lwfinger.net> <201204172035.06023.chunkeey@googlemail.com>
In-Reply-To: <201204172035.06023.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 01:35 PM, Christian Lamparter wrote:
> On Tuesday, April 17, 2012 07:25:25 PM Larry Finger wrote:
>> Christian,
>>
>> A question regarding adding carl9170-1.fw to the openSUSE firmware package is
>> being discussed on the oS kernel mailing list; however, I do not see that one
>> in the linux-firmware git repo. Should it be there?
> Does the repo take source code releases? [much like the work we do for the
> kernel driver, or have you ever seen a binary release on this ML :D ]. The
> files on<http://wireless.kernel.org/en/users/Drivers/carl9170#Firmware_binary>
> are just for convenience.

AFAIK, the repo only takes binary files. With the source under GPL2, that should 
not be a problem; however, the fact that there are two versions with the same 
name would be trouble. Adding under that name has the possibility of breaking 
all the systems that use the other version.

Too bad that the newer firmware was not renamed carl9170-2.fw. Then both could 
be added to the repo and the driver could load whichever one it needed. 
Unfortunately, making that change now would be difficult to propagate back to 
all the stable versions, but you might consider it for V3.5 and forward. In 
conjunction with that change, submit the newer firmware to the firmware repo 
with the -2 name. That won't break anyone's system. Users for kernels up to 3.4 
will still see what they did before.

>> Is there a legal problem with redistribution?
> Not that I know of.

With a GPLv2 license, there will be no problem.

Larry


> Regards,
> 	Christian
>

