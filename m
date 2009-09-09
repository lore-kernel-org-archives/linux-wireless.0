Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35484 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZIIICi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 04:02:38 -0400
Received: by ewy2 with SMTP id 2so3469652ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 01:02:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA67009.4020400@lwfinger.net>
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de>
	 <4AA67009.4020400@lwfinger.net>
Date: Wed, 9 Sep 2009 16:02:39 +0800
Message-ID: <a8e1da0909090102t1d6f3380y94683a188c09db06@mail.gmail.com>
Subject: Re: b43 dma error
From: Dave Young <hidave.darkstar@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
	netrolller.3d@gmail.com, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 8, 2009 at 10:54 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> Michael Buesch wrote:
>> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
>>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
>>> then the controller keep restarting...
>>>
>>> Please tell what I can provide or test, Thanks.
>>
>> Is this a regression? If so, please bisect.
>
> It is something specific to his system as I don't see anything like
> this. In addition, there are some users on the openSUSE forums that
> have implemented the latest compat-wireless and switched away from
> Broadcom wl to b43 on their LP PHY devices. So far, no complaints from
> them.
>
> Please reboot so that we see the ssb output as well. Use the command
>
> dmesg | egrep "ssb|b43"
>
> That way we will be able to see exactly what kind of device you have
> and what revisions are in it. AFAIK, the testing to date has been
> limited to Rev 1 PHYs and Rev 2 radios.

I use a public pc and I have no lan access for my laptop, so just hand
copy something:

b43-pci-bridge 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
b43-pci-bridge 0000:0c:00.0: setting latency timer to 64
ssb SInics Silicon Backplane found on PCI device 0000:0c:00.0
b43-phy0: Broadcom 4312 WLAN found (core revision 15)
b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2

>
> Larry
>
>
>



-- 
Regards
dave
