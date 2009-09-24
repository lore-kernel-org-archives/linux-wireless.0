Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56154 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751890AbZIXTzT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 15:55:19 -0400
From: Malte Gell <malte.gell@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: ar9170 makes machine hang when shut down
Date: Thu, 24 Sep 2009 21:55:19 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909242155.19485.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I use the compat 2.6.30 and the ar9170 driver for my Netgear WN111 USB stick. 
I use the packages from
http://download.opensuse.org/repositories/driver:/wireless/11.1-update/i586/
for openSUSE 11.1.

When I shutdown my machine, it hangs after the last messages "system now 
rebooting" or similar.

Does it make sense to use "rmmod --force ar9170" to force removing that module 
before shutting down?

Thanx
Malte
