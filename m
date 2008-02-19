Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:35249 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYBSPzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 10:55:14 -0500
Date: Tue, 19 Feb 2008 16:39:10 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: ipw3945-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Recent driver in linux kernel 2.6.25-rc2
Message-ID: <20080219153910.GA4303@ics.muni.cz> (sfid-20080219_155519_741505_C84D1CC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

as of pre 2.6.25 kernels, kismet monitoring tool does not work with the=
 message:
# kismet
Launching kismet_server: //usr/bin/kismet_server
Suid priv-dropping disabled.  This may not be secure.
No specific sources given to be enabled, all will be enabled.
Non-RFMon VAPs will be destroyed on multi-vap interfaces (ie, madwifi-n=
g)
Enabling channel hopping.
Enabling channel splitting.
Source 0 (iwl4965): Enabling monitor mode for iwl4965 source interface =
wlan0
channel 6...
=46ATAL: Failed to set channel 6 5:Input/output error
Done.

the same tool works in 2.6.24 kernel.

I have 03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 =
AG or
AGN Network Connection (rev 61), 8086:4230=20

I have ThinkPad T61 laptop.

Btw, will there be support for LED with iwl4965 driver?

The driver version is 1.2.23ks.

--=20
Luk=E1=B9 Hejtm=E1nek
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
