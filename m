Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:56431 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbdJSCAE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 22:00:04 -0400
Received: by mail-oi0-f48.google.com with SMTP id v9so12195524oif.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Oct 2017 19:00:04 -0700 (PDT)
Subject: Re: rtlwifi oops
To: nirinA <nirina.raseliarison@gmail.com>,
        James Cameron <quozl@laptop.org>,
        linux-wireless@vger.kernel.org
References: <cf61cfda-1e32-3ec3-d558-b508c3b923b6@gmail.com>
 <20171018223320.GB641@us.netrek.org>
 <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com>
 <fcf4b761-d7bd-7956-fa98-07fd8b2f8c3b@lwfinger.net>
 <b86480bd-49b9-f7ac-5dc5-6f6f83942727@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d65baa01-c842-0d14-5760-bbc1c754b1e6@lwfinger.net> (sfid-20171019_040008_208852_E18CD1B1)
Date: Wed, 18 Oct 2017 21:00:02 -0500
MIME-Version: 1.0
In-Reply-To: <b86480bd-49b9-f7ac-5dc5-6f6f83942727@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2017 08:40 PM, nirinA wrote:
> i checked my dmesg and have this similar log, i think when i unplugged the device.
> 
> [ 5640.100541] usb 2-1.4: USB disconnect, device number 5
> [ 5640.104108] rtl_usb: reg 0x102, usbctrl_vendorreq TimeOut! status:0xffffffed 
> value=0x0
> [ 5640.104110] rtl_usb: reg 0x422, usbctrl_vendorreq TimeOut! status:0xffffffed 
> value=0x0
> [ 5640.104113] rtl_usb: reg 0x542, usbctrl_vendorreq TimeOut! status:0xffffffed 
> value=0x0
> [ 5640.104127] rtl_usb: reg 0x102, usbctrl_vendorreq TimeOut! status:0xffffffed 
> value=0xd38000
> 
> i will apply the patch and will see if i still get this.

As I said in the response to your private message:

No, that is a different error. You need to check for the USB disconnect when 
starting, but no rtl_usb errors.

Larry
