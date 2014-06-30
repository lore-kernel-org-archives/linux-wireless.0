Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tomasu.net ([192.241.222.217]:35898 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbaF3Vv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 17:51:56 -0400
Received: from balsa.localnet (S0106000024ce8134.ed.shawcable.net [174.3.73.24])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: thomas@fjellstrom.ca)
	by mail.tomasu.net (Postfix) with ESMTPSA id BA69714EB33
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 21:43:37 +0000 (UTC)
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
To: linux-wireless@vger.kernel.org
Reply-To: thomas@fjellstrom.ca
Subject: Linux iwlwifi 801.11n speeds
Date: Mon, 30 Jun 2014 15:43:36 -0600
Message-ID: <2766921.O7z3bAoKY3@balsa> (sfid-20140630_235204_092217_3B11356D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been doing some reasearch and testing lately, and have noticed that 
802.11n speeds in linux on two iwlwifi devices (6300, 6205) are anywhere from 
20 to 40mbps slower than in windows 7.

I've tried enabling swcrypto and disabling power management, and neither help.

While signal strength seems to be better in windows based on the signal meter, 
they may just calculate signal bars differently. I don't know.

Is there anything I can do to achieve similar speeds? I easily reach 90+ mbps 
in windows, and rarely reach 70 mbps in linux.

I'm running debian sid, with the 3.14.7 and 3.14.4 debian kernels, and should 
have the latest iwlwifi firmware.

I have a dual band Ubiquity AP Pro ap connected to a Sokeris 6501-50 firewall 
appliance running debian sid as well, and connected to a full GbE lan, which 
regularly achieves full speeds of 90MBps+. All settings on the actual network 
were not changed between speed tests. N was tested solely on the 5Ghz band, 
channel 36, and there is very little interference here on 5ghz. There is one 
other network visible and its on the other end of the 5ghz band.

Oh, and my nexus 7 (2013) also achieves 90mbps+, it may even get better, but I 
haven't managed to test local speeds, just tested with the speedtest.net app, 
and my internet is 100mbps, so it pretty much maxes it out.

Thank you for any assistance.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
