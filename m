Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:60732 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaB0POe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 10:14:34 -0500
Received: by mail-ve0-f173.google.com with SMTP id jw12so3975393veb.32
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 07:14:33 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 27 Feb 2014 10:14:33 -0500
Message-ID: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com> (sfid-20140227_161437_552680_8A64D0B7)
Subject: pci-half-mini 7260 Wireless AC support 3.13
From: Tim Nelson <tim.l.nelson@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am currently running a mainline ubuntu 3.13.5 lowlatency kernel with
the lastest intel firmware:

iwlwifi-7260-ucode-22.15.8.0.tgz

Linux nix-tn 3.13.5-031305-lowlatency #201402221823 SMP PREEMPT Sat
Feb 22 23:51:31 UTC 2014 i686 i686 i686 GNU/Linux

I am unable to connect to the wireless AC radios on my 3702
Lightweight AP that is connected to a Cisco 5508 controller.  On the
controller, I do see clients hitting the AC radios on the SSID.  I am
only connecting to the A/N radio however at 5ghz.

Is AC truly supported currently?  I heard the patches for it would be
applied in 3.13 but when I do a iwconfig wlan0 I only see:
wlan0     IEEE 802.11abgn

This leads me to believe that it's not actually supported yet.
However, this could be something aesthetic with iwconfig.
