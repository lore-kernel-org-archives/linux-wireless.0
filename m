Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:33046 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751803Ab1FJHh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 03:37:27 -0400
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: iwlagn module ignores parameter "led_mode=1" under certain conditions
Date: Fri, 10 Jun 2011 09:37:22 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106100937.23295.toralf.foerster@gmx.de> (sfid-20110610_093738_848115_CB8A146C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Since years this worked at my Gentoo system :

$ cat /etc/modprobe.d/iwlagn.conf 
options iwlcore led_mode=1

However nowadays this doesn't work when I do the following :

1. dock the ThinkPad T400 (no WLAN, only DSL)
2. boot it
3. s2ram it
4. undock it
5. go into the office
6. resume the undocked notebook (WLAN, no DSL)

The led is blinking ...

Putting however this line into the config file :
$ options iwlagn  led_mode=1

works always.

?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
