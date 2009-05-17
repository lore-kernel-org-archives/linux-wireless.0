Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:50649 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbZEQJIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 05:08:43 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M5cMK-00073h-Dc
	for linux-wireless@vger.kernel.org; Sun, 17 May 2009 09:08:40 +0000
Received: from cac94-1-81-57-151-96.fbx.proxad.net ([81.57.151.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 09:08:40 +0000
Received: from castet.matthieu by cac94-1-81-57-151-96.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 09:08:40 +0000
To: linux-wireless@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: b43 : under high load, ack are lost
Date: Sun, 17 May 2009 09:08:29 +0000 (UTC)
Message-ID: <loom.20090517T085823-487@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I use a 4306 (core rev 5) with compat-wireless-2009-05-08 as wireless driver and
4.150.10.5 firmware.
My station is an airo card in wpa-psk mode (802.11b).

After resolving my beacon problem [1], when I download at max speed my station
disconnect from AP because "LostSync-MaxRetry".
After looking in my station statistic it seems the retry (RetryLong) are due to
noack received from the AP.

Who is responsible to generate ack ?
The firmware or the mac80211 stack ?

Any idea to investigate this ?

Thanks

Matthieu 



[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/32845

