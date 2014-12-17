Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33439 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLQRUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 12:20:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Y1IGZ-00026Y-At
	for linux-wireless@vger.kernel.org; Wed, 17 Dec 2014 18:20:03 +0100
Received: from 165.95.118.120 ([165.95.118.120])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 18:20:03 +0100
Received: from avicalc by 165.95.118.120 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 18:20:03 +0100
To: linux-wireless@vger.kernel.org
From: Mike <avicalc@gmail.com>
Subject: Sporadic System Lockup in Monitor Mode
Date: Wed, 17 Dec 2014 17:10:04 +0000 (UTC)
Message-ID: <loom.20141217T174136-285@post.gmane.org> (sfid-20141217_182012_887608_9AB6BBDD)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using the rt3070sta driver on an SBC from Technologic Systems (TS-
7800) for Linux 2.6.21. I have used several USB adapters and they all have 
this issue so I don't think it's adapter specific. One example is this 
Hawking adapter (http://hawkingtech.com/products/view/174/396.html).



My application runs the interface in monitor mode. I have devices in 
various locations and some run for months with no issues. However, in other 
locations, putting my adapter into monitor mode immediately freezes my 
system, only fixed by a power cycle. Rebooting results in a system freeze 
after monitor mode is invoked. Moving the troublesome devices to a 
different location will fix the issue so it's not device specific. It is 
almost as if the Wi-Fi driver sees some kind of AP, gets confused and 
freezes up. So, my issue is location specific-for instance in a particular 
building. I've tried changing the Wi-Fi channel and this is effective 
sometimes (particularly on channels 3 and 8) but it's inconsistent. System 
logs and dmesg show me nothing. Is there something else I can do to try and 
prevent this issue beyond getting compat-wireless working on my SBC?

