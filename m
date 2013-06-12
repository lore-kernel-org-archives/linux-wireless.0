Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linicks.net ([87.127.191.50]:48647 "EHLO mail.linicks.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab3FLLeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 07:34:03 -0400
Date: Wed, 12 Jun 2013 12:23:26 +0100
From: Nick Warne <nick@linicks.net>
To: linux-wireless@vger.kernel.org
Subject: [QUERY] Intel Centrino Wireless-N 100 modules vs built-in
Message-ID: <20130612112326.GA10313@sauron> (sfid-20130612_133412_709863_242F03A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Devs,

I have a strange query.  Building a custom kernel on my Samsung N145 notebook I came a cropper.

05:00.0 Network controller: Intel Corporation Centrino Wireless-N 100

If I select:

Device Drivers->Network Device Support->Wireless LAN

<M>   Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi)
-M-   Intel Wireless WiFi DVM Firmware support

all is hucky dory.  But if I build-in these drivers into kernel (<*>), on boot dmesg reports:

[2.347954] iwlwifi 0000:05:00.0: request for firmware file 'iwlwifi-100-5.ucode' failed.
[2.351885] iwlwifi 0000:05:00.0: no suitable firmware found!

Am I missing something here - I don't quite understand why this happens?

Any help appricated please.

Please CC any replies please, I am not subscribed.

Nick 
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
