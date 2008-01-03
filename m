Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:32640 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYACXLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2008 18:11:38 -0500
Received: by py-out-1112.google.com with SMTP id u52so10742526pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2008 15:11:36 -0800 (PST)
Message-ID: <43e72e890801031511g1db178a0v90f7b3ed8e866e9e@mail.gmail.com> (sfid-20080103_231145_402745_571765B9)
Date: Thu, 3 Jan 2008 18:11:35 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: rtl8187 Failed to select rate control algorithm 2.6.24-rc6
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <476FD6F0.4010605@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <476FD6F0.4010605@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apologies for the delay, this should be fixed now.

  Luis

On Dec 24, 2007 10:57 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Hi
>
> The compat-wireless-2.6 package is compiling on Kernel 2.6.24-rc6.
>
> Now I have the next problem. I want to load the rtl8187 module out of
> the compat-wireless-2.6 package into kernel 2.6.24-rc6, but I get the
> following message:
>
> phy0: Failed to select rate control algorithm
> phy0: Failed to initialize rate control algorithm
> rtl8187: Cannot register device
> rtl8187: probe of 6-3:1.0 failed with error -2
> usbcore: registered new interface driver rtl8187
>
> And no wireless device is created at iwconfig
>
>
> When loading the module from vanilla kernel 2.6.24-rc6 it prints out the
> following messages:
>
> phy0: Selected rate control algorithm 'simple'
> phy0: hwaddr 00:15:af:03:ab:79, rtl8187 V1 + rtl8225z2
> usbcore: registered new interface driver rtl8187
>
> And a wireless device is created at iwconfig and everything is working
> as it should.
>
> I downloaded the compat-wireless-2.6 package 1 hour ago.
>
> I have got the same problem on kernel 2.6.22.
> I loaded the following modules:
> cfg80211.ko ; mac80211.ko ; eeprom_93cx6.ko ; rtl8187.ko
>
> --
> Merry Christmas
>
> Hauke Mehrtens
>
