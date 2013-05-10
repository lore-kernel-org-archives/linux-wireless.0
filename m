Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49945 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab3EJQkI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 12:40:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UaqMV-0007vm-Ey
	for linux-wireless@vger.kernel.org; Fri, 10 May 2013 18:40:03 +0200
Received: from 136.159.99.57 ([136.159.99.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 May 2013 18:40:03 +0200
Received: from cyrilseg by 136.159.99.57 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 May 2013 18:40:03 +0200
To: linux-wireless@vger.kernel.org
From: Cyril <cyrilseg@gmail.com>
Subject: implement admission control algorithm
Date: Fri, 10 May 2013 16:37:15 +0000 (UTC)
Message-ID: <loom.20130510T183525-479@post.gmane.org> (sfid-20130510_184013_121609_C094A0FC)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am a student in thesis and my work brings me to use ath9k driver and 
hostapd.
I am currently working to enhance video streaming on 802.11 WLAN with Quality 
Of Service by implement a call admission control algorithm.
So I need to modify the hostapd source code or aht9k source code to add a 
function for the admission control for new stations.
But I don't know where I have to implement this function and where I need to 
call it to works well...
If someone could help me, I would be grateful.

Thanks,

Cyril S.

