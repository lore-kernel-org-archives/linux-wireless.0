Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:53733 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab3BRUMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 15:12:08 -0500
Received: by mail-bk0-f44.google.com with SMTP id j4so2712967bkw.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 12:12:05 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Markus Ulfberg <jag@markusulfberg.se>
Subject: Re: Prism54 issues after kernel upgrade
Date: Mon, 18 Feb 2013 21:12:03 +0100
Cc: linux-wireless@vger.kernel.org
References: <CACNBsWgOu3xFS+kV7-C5rWW0hvTtVgweCJpmacppKWwU7mpREQ@mail.gmail.com>
In-Reply-To: <CACNBsWgOu3xFS+kV7-C5rWW0hvTtVgweCJpmacppKWwU7mpREQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302182112.03235.chunkeey@googlemail.com> (sfid-20130218_211212_218566_4CB8B10B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Monday, February 18, 2013 08:33:59 PM Markus Ulfberg wrote:
> I recently upgraded from Debian Lenny to Squeezy and noticed that the
> prism54 driver started spitting out these messages in the syslog:
> Feb  1 23:05:23 lappy586 kernel: [  789.291198] p54pci 0000:01:00.0:
> rx'd frame size exceeds length threshold.
> Feb  1 23:05:23 lappy586 kernel: [  789.292165] p54pci 0000:01:00.0:
> rx'd frame size exceeds length threshold.
> Feb  1 23:05:23 lappy586 kernel: [  789.297478] p54pci 0000:01:00.0:
> rx'd frame size exceeds length threshold.
>
> Well actually I noticed because this is usually followed by a dropped
> connection for all my wireless devices in the house.
Is lappy586 your access point? Or do you think/know it
causes unwanted interference with other devices on your
wireless network? (Also, how regular is this DoS?)

> I'm running kernel: 2.6.32-5-486 from the debian repositories.
> My wireless device is the 3Com OfficeConnect Wireless 11g PC Card (3CRWE154G72)
>
> As far as I know this worked fine until I updated the kernel, if
> memory serves me right I was running something like 2.6.24...
The message "rx'd frame size exceeds length threshold" simply
states that the driver has received "garbage" from the device.
What firmware are you using? Because you said you upgraded from
2.6.24?, so you are probably are still running 2.7.0.0, Or? 
If you can you should go for 2.13.25.0
<http://wireless.kernel.org/en/users/Drivers/p54#firmware>
 
> I'll be happy to provide more information if you require,
It would be great if you could try a current p54pci driver.
(You don't have to compile a new 3.8-rc7 kernel for that,
you can get compat-drivers backports from:
<https://backports.wiki.kernel.org/index.php/Main_Page>)

> Thanks for providing a driver for my card. I really appreciate
> all the effort you have put into it!
Let's see what we can do ;-)

Regards,
	Christian
