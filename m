Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:35493 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751890Ab2AGK1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 05:27:14 -0500
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: suggestion for a reasonable value for /sys/module/iwlwifi/parameters/debug
Date: Sat, 7 Jan 2012 11:27:05 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201201071127.06717.toralf.foerster@gmx.de> (sfid-20120107_112731_971611_4E3BE93B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If I choosed 0x43ff my syslog message files exploded - and I'd like to trouble 
shoot a problem with my wlan at a ThinkPad T400 (iwlwifi, 5100 AGN controler). 
The symptoms are that 1-2 times in a hour the network stops working without 
any message in /var/log/messages (kernel 3.0.x, 3.1.x, 3.2.0 tested).

Thanks for any advice
-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
