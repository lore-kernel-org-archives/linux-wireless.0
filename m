Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44231 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2BANRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 08:17:45 -0500
Received: by bkcjm19 with SMTP id jm19so1012180bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 05:17:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Prashant Badsheshi <prashant.badsheshi@gmail.com>
Subject: Re: Regarding carl9170 wifi linux driver
Date: Wed, 1 Feb 2012 14:17:28 +0100
Cc: linux-wireless@vger.kernel.org
References: <CA+cdTWaGcDasoAQc8h7hdexpfwp4dtu-3EqcPNGp4b-UK9xgrw@mail.gmail.com>
In-Reply-To: <CA+cdTWaGcDasoAQc8h7hdexpfwp4dtu-3EqcPNGp4b-UK9xgrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201202011417.28603.chunkeey@googlemail.com> (sfid-20120201_141748_541415_DAF7D342)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, February 01, 2012 03:18:14 AM Prashant Badsheshi wrote:
> We are planning to use the below wifi dongle as station and AP.
> https://www.thinkpenguin.com/gnu-linux/penguin-wireless-n-usb-adapter
The chip AR9170 is getting on a bit. But ok.
 
> We got the linux driver from the below path
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> 
> We found the driver source in drivers/net/wireless/ath/carl9170.

A (compiled) firmware is available from:
http://wireless.kernel.org/en/users/Drivers/carl9170

and the firmware source from:
https://github.com/chunkeey/carl9170fw
 
> Our Question:
> 
> Is the carl9170 driver present in the above folder is a complete open
> source driver?
The driver and firmware are GPLv2 code.

> Also it would be great if there is any design document or programmer’s
> document for the above mentioned Wifi dongle chipset available.
Well, the original vendor firmware:
http://linuxwireless.org/en/users/Drivers/ar9170.fw
and the original vendor driver:
[ The most up-to-date version is available from the
kernel git. Just revert "staging: remove the Atheros otus vendor driver"
cff55f50b882b197a52c4cf0108a43c615d1fdba ] 

For more [HW design docs, register file, etc...] you need to talk to
Qualcomm Atheros. But if there's an open issue/specific question I
would be glad to help as well [or forward the request].

Regards,
	Chr
