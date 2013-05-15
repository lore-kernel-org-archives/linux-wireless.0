Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48566 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab3EOWm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 18:42:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UckOu-0006z0-MD
	for linux-wireless@vger.kernel.org; Thu, 16 May 2013 00:42:25 +0200
Received: from 136.159.99.57 ([136.159.99.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 May 2013 00:42:24 +0200
Received: from cyrilseg by 136.159.99.57 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 May 2013 00:42:24 +0200
To: linux-wireless@vger.kernel.org
From: Cyril Seg <cyrilseg@gmail.com>
Subject: STA doesn't support ACM for QoS
Date: Wed, 15 May 2013 22:42:09 +0000 (UTC)
Message-ID: <loom.20130516T003547-82@post.gmane.org> (sfid-20130516_004230_248197_44080042)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello ,

In my testbed, there is an AP that works with ath9k_htc and hostapd and there 
also are 2 STAs that work with ath9k_htc.
Video flows aren't in the good priority, they are in Best_Effort.
But if I enable the ACM parameter for VIDEO and BEST EFFORT, video flows are 
now in BACKGROUND priority.
STAs doesn't support the admission control ...

Does someone have a solution ?

I work with Kali Linux, kernel 3.7

Thanks,

Cyril Segretain

