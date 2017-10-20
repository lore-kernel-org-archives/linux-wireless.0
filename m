Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46825 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdJTAAG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 20:00:06 -0400
Received: by mail-wr0-f196.google.com with SMTP id l1so9896650wrc.3
        for <linux-wireless@vger.kernel.org>; Thu, 19 Oct 2017 17:00:06 -0700 (PDT)
Subject: Re: rtlwifi oops
To: Larry Finger <Larry.Finger@lwfinger.net>,
        James Cameron <quozl@laptop.org>,
        linux-wireless@vger.kernel.org
References: <cf61cfda-1e32-3ec3-d558-b508c3b923b6@gmail.com>
 <20171018223320.GB641@us.netrek.org>
 <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com>
 <fcf4b761-d7bd-7956-fa98-07fd8b2f8c3b@lwfinger.net>
 <b86480bd-49b9-f7ac-5dc5-6f6f83942727@gmail.com>
 <d65baa01-c842-0d14-5760-bbc1c754b1e6@lwfinger.net>
From: nirinA <nirina.raseliarison@gmail.com>
Message-ID: <d9e6052f-cc92-813b-6cd6-9907f5bd82be@gmail.com> (sfid-20171020_020010_786776_3DC99426)
Date: Fri, 20 Oct 2017 03:08:39 +0300
MIME-Version: 1.0
In-Reply-To: <d65baa01-c842-0d14-5760-bbc1c754b1e6@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On 10/18/2017 08:40 PM, nirinA wrote:
>> i checked my dmesg and have this similar log, i think when i 
>> unplugged the device.
>>
>> [ 5640.100541] usb 2-1.4: USB disconnect, device number 5
>> [ 5640.104108] rtl_usb: reg 0x102, usbctrl_vendorreq TimeOut! 
>> status:0xffffffed value=0x0
>> [ 5640.104110] rtl_usb: reg 0x422, usbctrl_vendorreq TimeOut! 
>> status:0xffffffed value=0x0
>> [ 5640.104113] rtl_usb: reg 0x542, usbctrl_vendorreq TimeOut! 
>> status:0xffffffed value=0x0
>> [ 5640.104127] rtl_usb: reg 0x102, usbctrl_vendorreq TimeOut! 
>> status:0xffffffed value=0xd38000
>>
>> i will apply the patch and will see if i still get this.
>
> As I said in the response to your private message:
sorry for the private mail, i press reply button instead of reply-all.
> No, that is a different error. You need to check for the USB 
> disconnect when starting, but no rtl_usb errors.
>
up to now, i have no error when plugging the device with the same 
machine. the  message above only appears from time to time, not always 
when i unplugged.
i also use 2 other rtl8192cu with a raspberry pi and a beaglebone black, 
but never checked any log when the connection with the devices failed; i 
just shut down and restart. i'll try to get more detail if some failure 
will occur with these devices.
> Larry
>
thanks,

---
nirinA
