Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33754 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbbHaRvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 13:51:20 -0400
Received: by obcji4 with SMTP id ji4so3630856obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 10:51:19 -0700 (PDT)
Subject: Re: RTL8189ETV
To: poma <pomidorabelisima@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
References: <55E47A27.4090703@gmail.com> <55E48988.1000803@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55E49415.7090807@lwfinger.net> (sfid-20150831_195123_579945_4BBE5054)
Date: Mon, 31 Aug 2015 12:51:17 -0500
MIME-Version: 1.0
In-Reply-To: <55E48988.1000803@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2015 12:06 PM, poma wrote:
> On 31.08.2015 18:00, poma wrote:
>>
>> Hi Fi,
>>
>> What is this device, is it supported by
>> https://github.com/orangepi-xunlong/linux-sunxi/tree/orangepi-3.4/drivers/net/wireless/rtl8189es
>>
>> $ modinfo rtl8189es
>> modinfo: ERROR: Module rtl8189es not found.
>>
>
> or is it supported by
> https://github.com/orangepi-xunlong/linux-sunxi/tree/orangepi-3.4/drivers/net/wireless/rtl8188eu
> https://github.com/lwfinger/rtl8188eu
> as RTL8188ETV is
>
> $ modinfo rtl8188eu
> modinfo: ERROR: Module rtl8188eu not found.
>
>
> However RTL8188ETV is USB 2.0 device,
> eeeeeeeeeeeeeeeeeee not again!

That last comment does not help.

If rtl8188eu is not available, that is the fault of your distro, not anything 
that driver maintainers can help. That driver is in the staging directory, and 
some distros do not include any of those drivers in their kernels.

eeeeeeeeeeeeeeeeeee not again! Someone posts about a USB device not found, and 
they refuse/fail to provide the USB ID. Why, I do not know when the lsusb 
command provides this info so easily.

Larry


