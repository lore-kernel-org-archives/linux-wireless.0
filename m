Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:65362 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3LOUun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 15:50:43 -0500
Received: by mail-la0-f47.google.com with SMTP id ep20so2316949lab.6
        for <linux-wireless@vger.kernel.org>; Sun, 15 Dec 2013 12:50:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUDGG1y3Qy5yqpwB2UzLthCm7P9Rk+zgHD4xoNzk9XuHkAo+w@mail.gmail.com>
References: <CANUDGG3bU9PkQgZYKFYAb31sN7xzvtAM0+xsasXpSgR5Q1CmHw@mail.gmail.com>
	<52AA7A57.9090902@gmail.com>
	<CANUDGG1y3Qy5yqpwB2UzLthCm7P9Rk+zgHD4xoNzk9XuHkAo+w@mail.gmail.com>
Date: Sun, 15 Dec 2013 22:50:41 +0200
Message-ID: <CANUX_P1eVaKkb_=Kx_8tUXsms5XVRAOPbg0vhc5zxrC+VZgRag@mail.gmail.com> (sfid-20131215_215058_302846_353CC203)
Subject: Re: Microcode crashes on Intel 7260
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: David Williams <xflow7@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> On Thu, Dec 12, 2013 at 10:09 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>>
>> On 12/12/2013 10:38 PM, David Williams wrote:
>>> Hello,
>>>
>>> I am a victim of the bug causing microcode crashes on Intel 7260.  I
>>> understand that new firmware is in the works that should resolve this.  I
>>> have two questions:
>>
>> Please share iw list output and dmesg output
>>
>>>
>>> 1) Is there any indication as to whether the new firmware/driver will make
>>> it into the 3.10 or 3.12 kernels?
>>>
>>
>> It is most probably a firmware issue - I'll know after you send the
>> output I mentioned above.

I got the firmware team to backport the fixes to the old code base
that works on 3.10.
firmware is here:
https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-7260-7.ucode.
I am waiting for a few feedbacks before I send the pull request.

>>
>>> 2) Is there a workaround using the existing firmware in the meantime?
>>>
>>
>> I am not aware of any microcode error we can workaround in the driver.
>> But you might be facing an issue I have never seen - please send the
>> output and we'll see.
>>
>>> Thanks,
>>>
>>> Dave Williams
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
