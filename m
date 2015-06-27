Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36177 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbF0RAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2015 13:00:34 -0400
Received: by wicnd19 with SMTP id nd19so40023185wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2015 10:00:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Realtek RTL8191SU really slow with =?UTF-8?B?4oCeTuKAnQ==?= mode enabled
Date: Sat, 27 Jun 2015 19:00:31 +0200
Message-ID: <1576201.5zzoPiW6A9@debian64> (sfid-20150627_190044_097907_179D0233)
In-Reply-To: <37780383.GGTrC2kAY2@linux-suse.hu>
References: <37780383.GGTrC2kAY2@linux-suse.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Saturday, June 27, 2015 11:16:21 AM Szőts Ákos wrote:
> I have a "0bda:8172 Realtek RTL8191SU 802.11n WLAN Adapter” working
> - previously with kernel v4.0 staging driver r8712u,
> - and now with wireless kernel v4.1 driver rtl8192su (from 
> https://github.com/chunkeey/rtl8192su).
> 
> My problem is when, by default, the 802.11n mode is enabled, the USB dongle's 
> connection speed is only around 1 Mb/s (with both drivers). When I turn it off 
> with "options rtl8192su ht_enable=0" in its config file, I get my full internet 
> speed, about 30 Mb/s.

Wait! There isn't any ht_enable option for the rtl8192su(.ko) driver...?!

> I'm asking whether it's a problem in the firmware or somewhere in the driver 
> code? If it's the latter case and you're interested in, I would like to help 
> debugging the problem and help you to fix this issue.
Can't help you with debugging the problem as long as I can't reproduce the
issue. No idea if this is a hardware, firmware, driver, setup or some
kind of interaction issue. In my opinion: you simply disable HT, then you
just did take a feature away rather than dealing with anything. But, if
that's what you want: fine.

Note: I think the simplest solution would be to have a working reference.
If you are looking for a wifi usb-stick, ath9k_htc solutions are usually
the way to go.

Regards,
  Christian
