Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm28-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.149]:22171 "HELO
	nm28-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754316Ab1ERITA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 04:19:00 -0400
Message-ID: <444460.90936.qm@web161614.mail.bf1.yahoo.com> (sfid-20110518_101905_700523_6EDD2436)
Date: Wed, 18 May 2011 01:18:59 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: rt2x00: rt2800usb causing kernel panic /compat-wireless/
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>, gwingerde@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A very peculiar bug.

With compat-wireless from 16.05 a nasty bug started to manifest itself. Right around association time, the rt2800usb causes kernel panic. The system freezes and the Caps Lock and Num Lock leds on the keyboard begin to flash.

Unfortunately there are no recoverable traces after the system failure to aid this bug report or to indicate its origin.

I believe it may somehow be related to Ubuntu's network-manager. If I turn off the network-manager service, I can go into monitor mode for example, but if network-manager is running and I plug my USB dongle, it starts to associate, a second or two later the system is in complete meltdown.

Nothing concrete, but a hunch is telling me this has something to do with the association mechanism of the rt2800usb. Compat-wireless from few days back exhibits no such foul play.

Walter
