Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:50509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbYGNINU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 04:13:20 -0400
Message-Id: <28167927.118721216023197288.JavaMail.servlet@kundenserver> (sfid-20080714_101325_371868_8251F6D5)
From: devel@e-doo.de
To: <linux-wireless@vger.kernel.org>
Subject: background scanning and fast handovers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Jul 2008 10:13:17 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Everybody,
I'm new on linux-wireless mailing list.

In the recent past I completed my diploma thesis, which included some software implementations with the Madwifi driver. In future the compact-wireless driver (with ath5k) will be used for Atheros Chipsets.
So - I'm very interessted to keep an eye on the development of the compact-wireless driver.
Maybe I can be a part in enhancing the driver in the future.

But first, I have a few questions to you:

How does the compact-wireless driver handle the case, when a connection of a STA to an AP gets lost?
Is there a solution for "fast handovers" between two APs?

Are there any activities to implement something like a "background scanning" in STA Mode?
A background scanning will allow a STA to observe the neighbourhood for new APs.

There are a few drivers that provide this functionality today.
The intention is to reduce Handover latency of a mobile STA, when it switches from one AP to an other AP.

What do you think:
Is it interessting for you, to work jointly on these challenges?

Jens
