Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44883 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbYLZLCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 06:02:47 -0500
Received: from math.ut.ee (math.ut.ee [193.40.36.2])
	by smtp2.it.da.ut.ee (Postfix) with ESMTP id 11BA373D5DD
	for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2008 13:02:44 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
	by math.ut.ee (Postfix) with ESMTP id 13398FD79B
	for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2008 13:02:44 +0200 (EET)
Date: Fri, 26 Dec 2008 13:02:43 +0200 (EET)
From: Meelis Roos <mroos@ut.ee>
To: linux-wireless@vger.kernel.org
Subject: RT2500 scan problem in 2.6.28
Message-ID: <Pine.SOC.4.64.0812261259030.13693@math.ut.ee> (sfid-20081226_120259_892575_8C162ACA)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I finally found a network where rt2x00 driver works reliably (using 
2.6.27). However, it does not work anymore with 2.6.28.

The network uses hidden SSID so wpa_supplicant is configured with 
ap_scan to find it. This works fine in 2.6.27 but the scan fails with 
2.6.28. Rugging wpa_supplicant in debug mode tells the scan finds a 
network with ssid='' and it does not match.

How can I debug it some more? I'm here with the network today and 
tomorrow, then I will leav for home.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
