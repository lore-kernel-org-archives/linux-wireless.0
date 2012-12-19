Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44423 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab2LSQo5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 11:44:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TlMlV-0004Kz-3S
	for linux-wireless@vger.kernel.org; Wed, 19 Dec 2012 17:45:05 +0100
Received: from aslw039181.ethz.ch ([129.132.39.181])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2012 17:45:05 +0100
Received: from dantard by aslw039181.ethz.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2012 17:45:05 +0100
To: linux-wireless@vger.kernel.org
From: Danilo <dantard@unizar.es>
Subject: Incoerency in iw (or mac80211 or drivers) behavior
Date: Wed, 19 Dec 2012 16:41:44 +0000 (UTC)
Message-ID: <loom.20121219T172801-213@post.gmane.org> (sfid-20121219_174500_837374_EED1E7EE)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I figured out that the command: 

iw dev wlan0 set bitrates legacy-5 24

has different behaviors in different devices.

With iwl3945 wireless cards, it fixes the rate at 24Mbps ALSO for multicast 
frames while in iwl4965 cards, it doesn't.


In both cases I tried with ubuntu linux 12.04 and kernel-3.2.0-32-generic using  
iwl4965/iwl_legacy driver for 4965 and iwl3945/iwl_legacy driver for 3945.


I've also tried with compat-wireless-3.6, same result.

What's the expected behavior? 

Thanks in advance,
 D. Tardioli




