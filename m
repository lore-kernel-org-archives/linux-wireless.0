Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33634 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab1GQSaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 14:30:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QiW6S-0002B0-QU
	for linux-wireless@vger.kernel.org; Sun, 17 Jul 2011 20:30:09 +0200
Received: from adsl-71-158-220-139.dsl.wchtks.sbcglobal.net ([71.158.220.139])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 20:30:08 +0200
Received: from anbarasans85 by adsl-71-158-220-139.dsl.wchtks.sbcglobal.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 20:30:08 +0200
To: linux-wireless@vger.kernel.org
From: Anbarasan <anbarasans85@gmail.com>
Subject: IEEE802.11 BEB Implementation
Date: Sun, 17 Jul 2011 18:29:01 +0000 (UTC)
Message-ID: <loom.20110717T202533-832@post.gmane.org> (sfid-20110717_203020_523344_08EE9078)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am Anbarasan. I want to modify the Binary Exponential Back-off (BEB) 
implementation of IEEE802.11 WLAN.
    
Can you help me in identifying the code section for BEB? BEB doubles the
contention window (cw) during transmission retry.

I googled but I could not find any. I browsed the source but I could not
identify the section that implements the BEB. 

Following is a comment in the file (driver/net/wireless/iwl-commands.h):
/*Device will automatically increase contention window by (2*CW) + 1 for each 
transmission retry.  Device uses cw_max as a bit mask, ANDed with new CW  value,
to cap the CW value.*/

The above is the BEB and I am looking for this implementation. I could not find
it. Kindly help. (I have a Intel Wireless card.)


Regards
Anbarasan

