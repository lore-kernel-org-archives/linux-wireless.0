Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60480 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab1ECKU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 06:20:27 -0400
Received: from localhost
	([127.0.0.1] helo=purkki.adurom.net ident=kvalo)
	by purkki.adurom.net with esmtp (Exim 4.69)
	(envelope-from <kvalo@adurom.com>)
	id 1QHCiQ-0007GT-4X
	for linux-wireless@vger.kernel.org; Tue, 03 May 2011 13:20:26 +0300
To: linux-wireless@vger.kernel.org
Subject: iwlagn: crash when unloading the module
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 03 May 2011 13:20:25 +0300
Message-ID: <87iptsgk5y.fsf@purkki.adurom.net> (sfid-20110503_122037_131544_93834E28)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I noticed today a crash when removing iwlagn module. I can see the
crash everytime on my lenovo x201 (x86 64bit, i5) with this wireless
chip:

[   19.484551] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R)
Ultimate-N 6300 AGN, REV=0x74

As I'm travelling I only have two bad quality screenshots and 40 MB
video of the crash :) From the stacktrace it looks that this is iommu
related:

http://www.adurom.com/~kvalo/tmp/iwlagn/rmmod-iommu-crash/1.png
http://www.adurom.com/~kvalo/tmp/iwlagn/rmmod-iommu-crash/2.png

This is a new laptop and most likely I haven't removed iwlagn module
before. So this shouldn't be a regression.

-- 
Kalle Valo
