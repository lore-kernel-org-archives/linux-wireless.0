Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54204 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab0IFCUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 22:20:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OsRJU-0008Se-9z
	for linux-wireless@vger.kernel.org; Mon, 06 Sep 2010 04:20:04 +0200
Received: from ppp121-44-8-149.lns20.syd6.internode.on.net ([121.44.8.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 04:20:04 +0200
Received: from msbroadf by ppp121-44-8-149.lns20.syd6.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 04:20:04 +0200
To: linux-wireless@vger.kernel.org
From: Michael <msbroadf@gmail.com>
Subject: =?utf-8?b?cnQyeDAwdXNiX3dhdGNoZG9nX3R4X3N0YXR1czo=?= Warning - TX queue 2 status timed out, invoke forced tx handler
Date: Mon, 6 Sep 2010 02:17:34 +0000 (UTC)
Message-ID: <loom.20100906T041329-313@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Im trying the latest compat-wireless 2010-09-05 and i am using a RALINK3027
802.11N wireless USB dongle.

I setup the wifi using hostapd in monitor and managed mode for this adapter, and
it sets up an AP ok, but i notice the following message quite frequently.

phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out,
invoke forced tx handler

appears very often and greatly interferes with the TX packets and makes the link
unusable.

Could someone tell me if this is being worked on, or if I can help somehow fix
it.  Im am a software engineer but don't have much kernel level experience.

Thanks,

Michael



