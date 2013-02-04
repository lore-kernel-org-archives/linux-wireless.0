Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f173.google.com ([209.85.213.173]:35846 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3BDVl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 16:41:59 -0500
Received: by mail-ye0-f173.google.com with SMTP id l5so1696622yen.4
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 13:41:58 -0800 (PST)
Message-ID: <51102B22.20702@gmail.com> (sfid-20130204_224203_236755_19964731)
Date: Mon, 04 Feb 2013 22:41:54 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Thomas Rosenkranz <tom.rosary@googlemail.com>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> You are likely crashing more than X.
> 
> That is very good evidence that rtl8192cu is *NOT* the correct driver for that 
> device. As I recall Xose found that USB ID in a Windows driver, but who knows 
> what changes are inside that driver?
> 
> I have what I think is a complete collection of Realtek drivers for Linux, and 
> none of them have 0bda:819a as a USB ID.

He's using the RTL8188C_8192C_USB_linux driver.
Therefore, there are only two possibilities:

- it's a 8192_du device, or
- it's a 8192_cu device, and there is a bug in rtlwifi.


Thomas, could you put "dmesg" output after loading 8192cu.ko (realtek driver) ?
and "lsusb -v -d 0bda:819a" output.
