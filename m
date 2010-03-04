Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:57683 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755393Ab0CDU3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 15:29:09 -0500
Message-ID: <4B901811.2030708@gmail.com>
Date: Thu, 04 Mar 2010 21:29:05 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Luis Correia <luis.f.correia@gmail.com>
CC: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: Linux 2.6.33 + Edimax EW-7318Ug?
References: <4B8F5228.4080001@freemail.hu> <efe7343f1003032339x32bd512et9eebe0518546cfee@mail.gmail.com>
In-Reply-To: <efe7343f1003032339x32bd512et9eebe0518546cfee@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/10 08:39, Luis Correia wrote:
> Hi!
> 
> 2010/3/4 Németh Márton <nm127@freemail.hu>:
>> Hi,
>>
>> I'm new to the Edimax EW-7318Ug ( http://www.edimax.com/en/produce_detail.php?pd_id=3&pl1_id=1&pl2_id=44 )
>> device. I could find out so far that there are different drivers for Linux
>> which can be used with this device. I think this device have the RT73 chip.
>>
>> I tried Linux kernel 2.6.33, compiled with CONFIG_RT2X00=m and CONFIG_RT2X00_DEBUG=y
>> (the full kernel config is attached). I copied the rt73.bin from
>> http://www.edimax.com/images/Image/driver/Linux%20driver/Wireless/USB%20adaptor/2008_0506_RT73_Linux_STA_Drv1.1.0.1.tar.zip
>> to /lib/firmware/rt73.bin .
> 
> While I'm not 100% sure, this may be one of those devices thas has
> it's ID in both rt2500usb and rt73usb.
> 
> Besides prying it open to see which is the actual chip used, there is
> little we can do, software side, to be sure of which exact driver
> should be used.
> 
> But to be honest, I can't really recall which exact driver ID conflict.
> 

By the looks of it (at the Edimax website) this is a true rt73 device. And that seems
to be supported by the dmesg output posted by Németh, where the loading of the rt2500usb
driver fails.

Németh, can you blacklist the auto-loading of the rt2500usb device (see
http://www.cyberciti.biz/tips/avoid-linux-kernel-module-driver-autoloading.html for how
to do this)?

---
Gertjan.
