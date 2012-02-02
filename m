Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49603 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2BBSXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 13:23:00 -0500
Received: by dadp15 with SMTP id p15so2050566dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 10:23:00 -0800 (PST)
MIME-Version: 1.0
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Thu, 2 Feb 2012 19:22:30 +0100
Message-ID: <CAO=xpBGPi7o+gi3bTb=9iML=bSqBog6okz-Z7X7tywqiwb=FaA@mail.gmail.com> (sfid-20120202_192305_988423_C756DF2C)
Subject: how to setup a wireless bridge (wds) without iwpriv?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have an ALIX board running voyage 0.8.0 (based on Debian 6.0.3
"Squeeze" - kernel 3.0.0)

Since wireless on my PC doesn't work properly, I'd like to create a
wireless bridge to allow a PC to get an IP address from the wireless
network without NAT.

(ISP wireless router - 192.168.1.1) <---wireless---> (ALIX setup as
bridge) <---wired---> (PC - 192.168.1.x)

If I connect to the wireless with wpa_supplicant and then try to
bridge eth0 and wlan0, I get an error.
Googleing I realized I need to set up wds (Wireless distribution system).

But all examples I can find for wds require the usage of iwpriv (to
handle WPA) but I can't on my system:

# iwpriv wlan0
wlan0     no private ioctls.

So my question is:

*** how can I setup a wds bridge using WPA between wireless (in
managed mode) and the wired interface? ***

thank you,
alfonso
