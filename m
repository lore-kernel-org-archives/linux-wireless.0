Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35767 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbHaVZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 17:25:15 -0400
Received: by obcbp4 with SMTP id bp4so31695585obc.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 14:25:14 -0700 (PDT)
Subject: Re: RTL8189ETV
To: poma <pomidorabelisima@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
References: <55E47A27.4090703@gmail.com> <55E48988.1000803@gmail.com>
 <55E49415.7090807@lwfinger.net> <55E4B9A2.8060109@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55E4C638.7010704@lwfinger.net> (sfid-20150831_232520_252559_CCE76DC4)
Date: Mon, 31 Aug 2015 16:25:12 -0500
MIME-Version: 1.0
In-Reply-To: <55E4B9A2.8060109@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2015 03:31 PM, poma wrote:
> On 31.08.2015 19:51, Larry Finger wrote:
>> On 08/31/2015 12:06 PM, poma wrote:
>>> On 31.08.2015 18:00, poma wrote:
>>>>
>>>> Hi Fi,
>>>>
>>>> What is this device, is it supported by
>>>> https://github.com/orangepi-xunlong/linux-sunxi/tree/orangepi-3.4/drivers/net/wireless/rtl8189es
>>>>
>>>> $ modinfo rtl8189es
>>>> modinfo: ERROR: Module rtl8189es not found.
>>>>
>>>
>>> or is it supported by
>>> https://github.com/orangepi-xunlong/linux-sunxi/tree/orangepi-3.4/drivers/net/wireless/rtl8188eu
>>> https://github.com/lwfinger/rtl8188eu
>>> as RTL8188ETV is
>>>
>>> $ modinfo rtl8188eu
>>> modinfo: ERROR: Module rtl8188eu not found.
>>>
>>>
>>> However RTL8188ETV is USB 2.0 device,
>>> eeeeeeeeeeeeeeeeeee not again!
>>
>> That last comment does not help.
>>
>> If rtl8188eu is not available, that is the fault of your distro, not anything
>> that driver maintainers can help. That driver is in the staging directory, and
>> some distros do not include any of those drivers in their kernels.
>>
>> eeeeeeeeeeeeeeeeeee not again! Someone posts about a USB device not found, and
>> they refuse/fail to provide the USB ID. Why, I do not know when the lsusb
>> command provides this info so easily.
>>
>> Larry
>>
>>
>
>
> What's the hurry, Larry.
> Let's see if Hans knows what type of this device is RTL8189ETV.
>
> According to what is written here
> http://linux-sunxi.org/Xunlong_Orange_Pi#Variants
> http://www.orangepi.org/orangepi2
> RTL8189ETV, whatever it is, is an integral part of some "O-Pi" variants.
>
> About rtl8188etv can be read here
> http://www.orangepi.org/orangepibbsen/forum.php?mod=viewthread&tid=25&highlight=wifi
> but there is no mention of RTL8189ETV.
>
> WikiDevi also returns nothing
> https://wikidevi.com/wiki/Main_Page
>    "Search results
>    ...
>    There were no results matching the query.
>
>    Create the page "RTL8189ETV" on this wiki!"
>
> I'm trying to determine in advance,
> what components are supported,
> what components are not supported,
> what components will never be supported,
> what components will never be supported in mainline kernel.
>
> Therefore, I can not show 'lsusb' output. :)
>
> "Distro" is not decisive in this matter, moreover dunno what are you referring with "your distro".
>
> eeeeeeeeeeeeeeeeeeeeee not again!

Silly me. I thought you were trying to get help implemetiing that device.


