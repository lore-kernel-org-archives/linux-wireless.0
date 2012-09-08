Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35184 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2IHANU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 20:13:20 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20554.36022.695344.376020@gargle.gargle.HOWL> (sfid-20120908_021335_734962_1A14E9C1)
Date: Sat, 8 Sep 2012 05:39:26 +0530
To: Koos Pol <koos2012@pohw.nl>
CC: <linux-wireless@vger.kernel.org>
Subject: Problems with Atheros AR54B22 (AR9462)
In-Reply-To: <504A2718.10805@pohw.nl>
References: <504A2718.10805@pohw.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Koos Pol wrote:
> Hi,
> 
> After receiving great help on irc #linux-wireless, I'd figure to post the
> results here in case someone wants to track this down.
> 
> I've installed openSUSE 12.2 on a brand new Acer V3-771 with the Atheros
> AR54B22 chipset. The ath9 driver works right out of the box. But.... My wlan
> router (Fritzbox 7170) doesn't seem to handle it very well, as it will
> drop/reset the wlan connection after a few seconds. Notably other wlan laptops
> are disconnected too. The whole wlan network seems to go astray.
> So it seems to be strongly related to the Fritzbox. I did manage to connect
> successfully to someone else's pub wifi.
> Is this something worth debugging (for the greater public as well)?
> 
> The response I got from irc (sacamano_m82) was to use the compat-wireless
> package as ath9k is still under development.
> 
> I did and I have perfect wlan connectivity now. Wlan is stable since. So that
> did the trick.

Nice.

> If anyone is interested in debugging this, I'm happy to help you in any way I
> can. Just tell me what to do. FYI, I'm not subscribed to this list.

Well, the kernel in openSUSE 12.2 probably doesn't have full support for AR9462 yet..

Sujith
