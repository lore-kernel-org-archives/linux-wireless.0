Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35154 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933426AbdC3OGM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 10:06:12 -0400
Received: by mail-yw0-f196.google.com with SMTP id k13so3598794ywk.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 07:06:11 -0700 (PDT)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] staging: Add rtl8723bs sdio wifi driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <20170329174751.13184-1-hdegoede@redhat.com>
 <2266f69c-2eda-fb94-e1c7-cf1bafeb7ad7@lwfinger.net>
 <20170330071515.GA4945@kroah.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        linux-wireless@vger.kernel.org
Message-ID: <d4f84482-1ed3-7ba5-10ba-406afbe2a372@gmail.com> (sfid-20170330_160707_133472_7DE0276F)
Date: Thu, 30 Mar 2017 10:06:09 -0400
MIME-Version: 1.0
In-Reply-To: <20170330071515.GA4945@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2017 03:15 AM, Greg Kroah-Hartman wrote:
> On Wed, Mar 29, 2017 at 08:20:19PM -0500, Larry Finger wrote:
>> On 03/29/2017 12:47 PM, Hans de Goede wrote:
>>> The rtl8723bs is found on quite a few systems used by Linux users,
>>> such as on Atom systems (Intel Computestick and various other
>>> Atom based devices) and on many (budget) ARM boards such as
>>> the CHIP.
>>>
>>> The plan moving forward with this is for the new clean,
>>> written from scratch, rtl8xxxu driver to eventually gain
>>> support for sdio devices. But there is no clear timeline
>>> for that, so lets add this driver included in staging for now.
>>>
>>> Cc: Bastien Nocera <hadess@hadess.net>
>>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>>> Cc: Jes Sorensen <jes.sorensen@gmail.com>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Hans,
>>
>> I am still building the driver on my CherryTrail tablet, but I did see some
>> warnings and errors listed by Smatch as follows:
>>
[snip]
>> The indent problems can probably be ignored, but many of the others are
>> serious enough to be addressed now.
>>
>> Once this driver is merged into staging, the Outreachy folks will be really busy.
>>
>> Thanks for posting this driver,
>
> So, no objection from you?  Great, I'll go queue it up later today...
>
> thanks,
>
> greg k-h
>

As much as I hate adding more Realtek vendor code to the kernel, I do 
agree this is the right thing to do in the interim. Not sure when I'll 
get to SDIO support in rtl8xxxu, but I will process patches, hint hint :)

Jes
