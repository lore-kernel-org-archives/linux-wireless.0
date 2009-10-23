Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53599 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZJWQTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:19:35 -0400
Received: by bwz27 with SMTP id 27so1005491bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2009 09:19:39 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Adhari" <wireless_support@adhari.de>
Subject: Re: D-link USB Wlan Adapter DWA 160A  crashes after a while
Date: Fri, 23 Oct 2009 18:19:40 +0200
Cc: linux-wireless@vger.kernel.org
References: <005001ca53e9$307bde30$91739a90$@de>
In-Reply-To: <005001ca53e9$307bde30$91739a90$@de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910231819.40826.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 October 2009 16:00:32 Adhari wrote:
> Hello Everybody
> 
> I´m usind a D-link USB Wlan Adapter DWA 160A (ar9170usb) under Debian (kernel 2.6.31)
> 
> First when I connect this device, everything is fine. I have to do some measurements concerning Mipv6 (I´m only using Ipv6 here)
> after a while using this W-lan Adapter (30 to 60mn) the system is not be able to receive any packets.
> 
> 
> The only solution is to plug the USB interface out and to connect it again.
> ifconfig down and up has no effect and sometimes rebooting either don´t correct this.
> 
> Any idea what the problem could be?
> [ 1270.206139] usb 5-2: kill pending tx urbs.

Is this some sort of trick question? Because you gave
the correct answer already in the "Subject" line?!

my suggestion:

1. get & compile compat-wireless (this will give you
	an updated ar9170usb.ko driver. http://linuxwireless.org/en/users/Download )

2. replace the old two-stage firmware files with one-stage ar9170.fw
   (link: http://wireless.kernel.org/en/users/Drivers/ar9170 )

Regards,
	Chr
