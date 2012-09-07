Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver9.axc.nl ([159.253.0.33]:43433 "EHLO vserver9.axc.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab2IGRZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:25:15 -0400
Received: from 84-245-10-224.dsl.cambrium.nl ([84.245.10.224] helo=[192.168.178.20])
	by vserver9.axc.nl with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <koos2012@pohw.nl>)
	id 1TA1qT-0000i1-Cc
	for linux-wireless@vger.kernel.org; Fri, 07 Sep 2012 18:55:53 +0200
Message-ID: <504A2718.10805@pohw.nl> (sfid-20120907_192542_327478_7D5EB140)
Date: Fri, 07 Sep 2012 18:55:52 +0200
From: Koos Pol <koos2012@pohw.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems with Atheros AR54B22 (AR9462)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After receiving great help on irc #linux-wireless, I'd figure to post the
results here in case someone wants to track this down.

I've installed openSUSE 12.2 on a brand new Acer V3-771 with the Atheros
AR54B22 chipset. The ath9 driver works right out of the box. But.... My wlan
router (Fritzbox 7170) doesn't seem to handle it very well, as it will
drop/reset the wlan connection after a few seconds. Notably other wlan laptops
are disconnected too. The whole wlan network seems to go astray.
So it seems to be strongly related to the Fritzbox. I did manage to connect
successfully to someone else's pub wifi.
Is this something worth debugging (for the greater public as well)?

The response I got from irc (sacamano_m82) was to use the compat-wireless
package as ath9k is still under development.

I did and I have perfect wlan connectivity now. Wlan is stable since. So that
did the trick.

If anyone is interested in debugging this, I'm happy to help you in any way I
can. Just tell me what to do. FYI, I'm not subscribed to this list.

Cheers,
Koos

-- 
http://www.malarianomore.org
For $10 a mosquito net + distribution + education + monitoring + evaluation.
