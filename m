Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38227 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1BUQnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 11:43:46 -0500
Received: by eyx24 with SMTP id 24so336547eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 08:43:45 -0800 (PST)
Message-ID: <4D62963D.9020806@lwfinger.net>
Date: Mon, 21 Feb 2011 10:43:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mathieu Malaterre <mathieu.malaterre@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Realtek RTL8192SE support ? (aka r8192se_pci)
References: <AANLkTinoU0Dxy2iAHEsprTbakrbs8a8vPARFW0odz4g9@mail.gmail.com> <4D628D75.1070907@lwfinger.net> <AANLkTim-=h6N5a=4gaA+42xoWHk3PY1jM8FU9fkJ3CJp@mail.gmail.com>
In-Reply-To: <AANLkTim-=h6N5a=4gaA+42xoWHk3PY1jM8FU9fkJ3CJp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2011 10:12 AM, Mathieu Malaterre wrote:
> On Mon, Feb 21, 2011 at 5:06 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> On 02/21/2011 03:35 AM, Mathieu Malaterre wrote:
>>>
>>> Dear all,
>>>
>>>    As far as I know driver for rtl8192su will be added to kernel
>>> 2.6.38. By any chance does anyone knows if rtl8192se will make it into
>>> this release ?
>>
>> As part of our collaborative effort, Realtek has sent me a mac80211-based
>> driver for the RTL8192SE. It will be submitted to the wireless mailing list
>> for review once the driver for the RTL8192CU is accepted. The earliest this
>> would happen is 2.6.39, but I think 2.6.40 is more realistic. I also have a
>> driver for the RTL8192DE that will follow the RTL8192SE.
>
> Dear Larry,
>
>    Thank you very much for taking the time to answer my question.
>    Would it be possible to be part of some kind of testing group for
> this 'new' driver. I have been using r8192se_pci (*) for a couple of
> days, but I have the feeling this driver keeps filling in my
> computer's memory. I have to reboot to clean the memory (I have not
> found any other way).
>
> Using linux 2.6.37 from debian unstable

It will take me a few days, but I should be able to send you patches to 
incorporate the rtl8192se driver.

Larry
