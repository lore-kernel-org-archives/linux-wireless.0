Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from momout1-smtp.messagingengine.com ([66.111.4.229]:49913 "EHLO
	momout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932788Ab3CGOgy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 09:36:54 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 2AEF51A57
	for <linux-wireless@vger.kernel.org>; Thu,  7 Mar 2013 09:25:47 -0500 (EST)
Message-Id: <1362666346.22280.140661201248433.42E3B535@webmail.messagingengine.com> (sfid-20130307_153709_183340_56201187)
From: =?UTF-8?Q?K=C3=A9vin=20THIERRY?= <kevinthierry@myopera.com>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
References: <1362663176.11919.140661201212753.170BABA0@webmail.messagingengine.com>
Subject: Fwd: Unable to activate WiFi p2p / WiFi Direct
Date: Thu, 07 Mar 2013 14:25:46 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I've been unable to activate the p2p feature on my WiFi dongle (which
otherwise works fine). 
iwpriv command returns "wlan1 no private ioctls."
I'm running Ubuntu 12.04 with kernel 3.5.0-25 and the WiFi dongle is a
Netgear model wna1000m (driver rtl8192cu).
I've also tried with kernel 3.8.2 with the same result.
Thanks,

Kévin THIERRY
