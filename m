Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:37684 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab3BGPUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 10:20:21 -0500
Received: by mail-bk0-f53.google.com with SMTP id j10so1238084bkw.12
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 07:20:19 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Tomasz Guszkowski <tsg@o2.pl>
Subject: Re: [PATCH] p54usb: corrected USB ID for T-Com Sinus 154 data II
Date: Thu, 7 Feb 2013 16:20:15 +0100
Cc: linux-wireless@vger.kernel.org
References: <20130206233951.0cf8e25b7963bbd170b37899@o2.pl>
In-Reply-To: <20130206233951.0cf8e25b7963bbd170b37899@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302071620.16014.chunkeey@googlemail.com> (sfid-20130207_162024_813521_CE788F40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, February 06, 2013 11:39:51 PM Tomasz Guszkowski wrote:
> On Tue, 5 Feb 2013, Christian Lamparter wrote:
> > OT: The latest supported firmware for LM87 is: 2.13.25.0.lm87.arm
> > Did you experience issues with the new version, or do you simply
> > stick with the old 2.13.1.0 because it does work just as well?
>
> I have just tested behavior of T-Com with 2.13.25.0.lm87.arm 
> (md5sum 39be687c87544b892e7a8ffe7ffd9371) in managed mode.
> Ewerything what was tested worked perfectly:
> 1. iwlist wlan0 scan
> 2. connecting to open network
> 3. connecting to WEP 128-bit
> 4. connecting to WPA-PSK (TKIP)
> 5. connecting to WPA2-PSK (AES)
> 
> I am particularly impressed by working WPA2, with 2.13.1.0
> it didn't work.
Ok, that is actually important. I didn't know that 2.13.1.0 
had problems with AES, I'll check that again. Thanks for 
letting me know about this.
 
> Thanks for pointing newer firmware, with WPA2 support it's
> an excellent, sensitive card despite its age.
:-) [But of course: the driver is not done yet, I hope I'll get
around and add the automatic-reset-when-firmware-crashes feature
in the near future.]  

Regards

Christian
