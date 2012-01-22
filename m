Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39376 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2AVCss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 21:48:48 -0500
Received: by yhoo21 with SMTP id o21so852734yho.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jan 2012 18:48:47 -0800 (PST)
Message-ID: <4F1B790C.20807@lwfinger.net> (sfid-20120122_034914_042285_DE010F4F)
Date: Sat, 21 Jan 2012 20:48:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kristoffer Janke <privat@kjanke.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: p54usb (LM87) not correctly working with usb1
References: <4F1A6F08.5040108@kjanke.com>
In-Reply-To: <4F1A6F08.5040108@kjanke.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2012 01:53 AM, Kristoffer Janke wrote:
> Hello,
> i have an older server that only has usb 1.1 ports and attached a "Siemens
> Gigaset USB Adapter 54 V2" (chip: ISL3887, vid/pid: 0x083a/0x4521), with the
> firmware http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.25.0.lm87.arm the
> device comes up and everything looks fine.
>
> the only problem is, that hostapd does not work correctly, no wlan client can
> connect (but the device is in their list).
> because i read somewhere that usb1.1 together with this device is not working
> correctly with hostapd, i tried it on a different machine, routed the device
> through virtual box usb driver and there it was working perfect; to check that
> its really a usb1.1 problem, i disabled the usb2.0 controllers and retried on
> that same machine -> not working, same behaviour as on the older server; i
> tested it again with usb 2.0 -> worked, 1.1 -> non working, 2.0 -> working.
>
> so it looks like there is something bahving wrong if the device is connected to
> an usb 1.0/1.1 port.
>
> im willing to debug this stuff if i get some pointers...

My Dell DW1450, which uses p54usb, does not work at all on a USB1.1 port. I 
tried with 3.3-rc1 from wireless-testing and with a 2.6.30 kernel. The failure 
does not appear to be a regression. With a 3.2 kernel, it it works fine on 
USB2.0 ports.

Larry

