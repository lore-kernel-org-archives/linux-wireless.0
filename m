Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60791 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3BJJYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2013 04:24:02 -0500
Received: by mail-ob0-f181.google.com with SMTP id ni5so5271480obc.12
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2013 01:24:01 -0800 (PST)
Received: from andy by mail.pileus.org with local (Exim 4.80.1)
	(envelope-from <andy@pileus.org>)
	id 1U4T8Y-0003MV-Bz
	for linux-wireless@vger.kernel.org; Sun, 10 Feb 2013 09:23:50 +0000
Date: Sun, 10 Feb 2013 09:23:50 +0000
From: Andy Spencer <andy753421@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: B43 disconnects with high power APs
Message-ID: <20130210092350.GB15680@pileus.org> (sfid-20130210_102421_551051_0123C800)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I've been using the b43 driver and have been getting frequent
disconnects while using WPA.

I noticed that this seems related to the "Power Setting" on my 2Wire
router. When the power is set to full (400 mW) I get disconnected every
few seconds. If I lower power setting to 50 mW I can stay connected for
days at a time. I also noticed that if I am near the router I get
disconnected more often than if I am farther away or in a different
room.

This seems to be quite the opposite of what I would expect. Can anyone
think of a reason that a *better* signal would lead to more disconnects,
or if there's anything I can do about it? With my home router I can just
lower the transmit power setting and it works fine, but I can't do that
when I am traveling or connected to someone else's access point.

For reference: 
   Wireless chip:   BCM4331
   Kernel version:  3.7.0
   wpa_supplicant:  0.7.3 and 2.0 (I tested both)
   b43 firmware:    5.100.138
   b43-fwcutter:    017
   b43 options:     tested with nohwcrypt=0/1 and qos=0/1
