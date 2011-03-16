Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55378 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1CPWfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 18:35:04 -0400
MIME-Version: 1.0
In-Reply-To: <201103170022.24290.mihai.dontu@gmail.com>
References: <201103170018.32061.mihai.dontu@gmail.com>
	<201103170022.24290.mihai.dontu@gmail.com>
Date: Wed, 16 Mar 2011 23:35:02 +0100
Message-ID: <AANLkTi=-B0e4VT_v+F23Q+hG_zn=JnVbmVHnFpETVrZu@mail.gmail.com>
Subject: Re: [b43] usb device disconnects automatically after 1s
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.og,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/16 Mihai Donțu <mihai.dontu@gmail.com>:
> Added linux-usb and linux-wireless to CC.
>
> On Thursday 17 March 2011 00:18:31 Mihai Donțu wrote:
>> Hi,
>>
>> I have just upgraded to 2.6.38 and discovered that I can't use my wireless
>> device (BCM4312 802.11a/b/g). I press Fn + F2, the bluetooth led lights
>> and after a second it turns off by itself. In dmesg I'm seeing the
>> following:
>>
>> [   88.167212] usb 1-2.2: new full speed USB device using ehci_hcd and
>> address 5
>> [   88.782330] usb 1-2.2: USB disconnect, address 5
>>
>> I switched to 2.6.37 until I'll have some time to bisect this. In the mean
>> time I have attached the output of lspci, interrupts and dmesg.

I suspect it's WMI related. What is your machine?

Please check:
https://bugzilla.kernel.org/show_bug.cgi?id=31002
http://comments.gmane.org/gmane.linux.acpi.devel/49577

I can't help you more, I just noticed such a issue reported on ACPI
ML, you have to dig into this yourself (or someone else may help you).

-- 
Rafał
