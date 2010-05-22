Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:50388 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab0EVIzP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 May 2010 04:55:15 -0400
Received: from [192.168.3.128]
	by mx2.digadd.de with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.69)
	(envelope-from <schmidt@digadd.de>)
	id 1OFk5t-0003TM-IB
	for linux-wireless@vger.kernel.org; Sat, 22 May 2010 10:30:05 +0200
Message-ID: <4BF795EB.9070902@digadd.de>
Date: Sat, 22 May 2010 10:29:31 +0200
From: "Christian P. Schmidt" <schmidt@digadd.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems connectring to an AP with Acer Aspire Revo
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

I do have an... interesting... problem with my HTPC, an Intel Atom 230 +
Nvidia ION powered Acer Aspire Revo box.

By default it ships with an Atheros Mini PCI Express card. However,
since my experience with this card isn't the best (and it did not
connect to my access point with wither the Madwifi-NG or the ath9k
driver) I replaced it with an Intel WiFi Link 5100.

However, even with the new card, I could not make any kernel from 2.6.32
to 2.6.34 connect to any of my access points. Those are a Telekom DSL
router and a Juniper NetScreen 5GT Wireless. I tried WEP64, WPA, WPA2,
and even no encryption at all. My laptop with an Intel WiFi Link 5300
has no problems whatsoever in any of the modes.

The card is working for sure, if I put the 5100 in my laptop it works.
Also I feel it's not related to configuration or software - I took my
laptop's WiFi Link 5300 and the laptop HDD, and booted the HTPC up with
those - no connection to the AP possible.

I'm a bit at a loss here as what to try more. My access point doesn't
even see a packet, but there's no rfkill switch anywhere (it's a
stationary machine anyway).

Regards,
Christiam
