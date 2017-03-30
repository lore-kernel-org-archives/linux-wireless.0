Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35249 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933048AbdC3PWx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 11:22:53 -0400
Received: by mail-wr0-f195.google.com with SMTP id p52so13115029wrc.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 08:22:51 -0700 (PDT)
Subject: Re: [PATCH] staging: Add rtl8723bs sdio wifi driver
To: Jes Sorensen <jes.sorensen@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <20170329174751.13184-1-hdegoede@redhat.com>
 <2266f69c-2eda-fb94-e1c7-cf1bafeb7ad7@lwfinger.net>
 <20170330071515.GA4945@kroah.com>
 <d4f84482-1ed3-7ba5-10ba-406afbe2a372@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        linux-wireless@vger.kernel.org
From: poma <pomidorabelisima@gmail.com>
Message-ID: <0b1a5ed1-c5d9-e9f2-8c58-6ebe39e3e47c@gmail.com> (sfid-20170330_172309_737991_F157D6FE)
Date: Thu, 30 Mar 2017 17:22:48 +0200
MIME-Version: 1.0
In-Reply-To: <d4f84482-1ed3-7ba5-10ba-406afbe2a372@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30.03.2017 16:06, Jes Sorensen wrote:
> On 03/30/2017 03:15 AM, Greg Kroah-Hartman wrote:
>> On Wed, Mar 29, 2017 at 08:20:19PM -0500, Larry Finger wrote:
>>> On 03/29/2017 12:47 PM, Hans de Goede wrote:
>>>> The rtl8723bs is found on quite a few systems used by Linux users,
>>>> such as on Atom systems (Intel Computestick and various other
>>>> Atom based devices) and on many (budget) ARM boards such as
>>>> the CHIP.
>>>>
>>>> The plan moving forward with this is for the new clean,
>>>> written from scratch, rtl8xxxu driver to eventually gain
>>>> support for sdio devices. But there is no clear timeline
>>>> for that, so lets add this driver included in staging for now.
>>>>
>>>> Cc: Bastien Nocera <hadess@hadess.net>
>>>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>>>> Cc: Jes Sorensen <jes.sorensen@gmail.com>
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>
>>> Hans,
>>>
>>> I am still building the driver on my CherryTrail tablet, but I did see some
>>> warnings and errors listed by Smatch as follows:
>>>
> [snip]
>>> The indent problems can probably be ignored, but many of the others are
>>> serious enough to be addressed now.
>>>
>>> Once this driver is merged into staging, the Outreachy folks will be really busy.
>>>
>>> Thanks for posting this driver,
>>
>> So, no objection from you?  Great, I'll go queue it up later today...
>>
>> thanks,
>>
>> greg k-h
>>
> 
> As much as I hate adding more Realtek vendor code to the kernel, I do 
> agree this is the right thing to do in the interim. Not sure when I'll 
> get to SDIO support in rtl8xxxu, but I will process patches, hint hint :)
> 
> Jes
> 

A day after tomorrow? :)
