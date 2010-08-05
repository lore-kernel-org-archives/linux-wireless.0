Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35916 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab0HEApH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 20:45:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Ogoa0-0007RT-TR
	for linux-wireless@vger.kernel.org; Thu, 05 Aug 2010 02:45:05 +0200
Received: from 216-31-249-246.static-ip.telepacific.net ([216.31.249.246])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 02:45:04 +0200
Received: from graman by 216-31-249-246.static-ip.telepacific.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 02:45:04 +0200
To: linux-wireless@vger.kernel.org
From: Gopal Raman <graman@arubanetworks.com>
Subject: ath5k : Channel 149 thru 161 not working with compat-wireless-2.6.34.1 
Date: Thu, 5 Aug 2010 00:15:36 +0000 (UTC)
Message-ID: <loom.20100805T020816-848@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
I have an internal ath5k (0x17AB:0x8331) NIC and with the old madwifi style
drivers (ath_pci ver 0.9.4.5) channels 149 thru 161 work fine. I'm able to rx/tx
frames.

With compat-wireless-2.6.34.1 running on 2.6.27.48 kernel, I can't receive (nor
tx) on channels 149 thru 161. The driver sets the channel without any errors.
But can't rx any frames. When I force transmit on these channels nothing is seen
on the air. Channels 36 thru 60 work fine

Is this a known issue ?

Thanks
-gopal

