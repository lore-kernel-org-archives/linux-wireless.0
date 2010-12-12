Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57801 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0LLJUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 04:20:06 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PRi68-0002i0-Co
	for linux-wireless@vger.kernel.org; Sun, 12 Dec 2010 10:20:04 +0100
Received: from 194.48.133.8 ([194.48.133.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 10:20:04 +0100
Received: from messier31 by 194.48.133.8 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 10:20:04 +0100
To: linux-wireless@vger.kernel.org
From: thomas <messier31@gmx.net>
Subject: carl9170 802.11n-AP
Date: Sun, 12 Dec 2010 09:17:32 +0000 (UTC)
Message-ID: <loom.20101212T101545-636@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using carl9170 as driver for my TP-Link WN821n wifi USB-stick. The stick 
works well in 802.11g master mode but frequently hangs up in 802.11n master 
mode. 
Now I read here http://wireless.kernel.org/en/users/Drivers/carl9170
that a "real" 802.11 AP is not supported by the hardware. What exactly means 
"real" and has this something to do with the frequently crashes in 802.11n 
master mode? 

I will post more specific information (hardware, driver version, logs, etc..) 
later. But if you can tell me already, this behaviour is expected because of 
hardware incompatibility, there is no need for this.

Kind regards,

Thomas

