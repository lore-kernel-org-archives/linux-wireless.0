Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:50175 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZHRU3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 16:29:44 -0400
Received: by fg-out-1718.google.com with SMTP id e12so668472fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 13:29:45 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 18 Aug 2009 22:29:25 +0200
Message-ID: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
Subject: [ANN] b43 LP-PHY support (BCM4310/4312/4315) now ready for testing!
To: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello World!

Great news for Broadcom BCM4310/4312/4315 (PCI 14e4:4315) users:
LP-PHY support is now at the point where it can be tested for functionality!

There are still problems with channel switching (a few patches ago,
only 802.11b/g channels 7 and 8 were working - no tests have been
performed since then) & TX is untested, but Larry has reported that he
can get scan results from channels 7 and 8. He doesn't have any AP on
these channels, so can't test if association works, but it should be
working too. It's also possible that recent patches have fixed the
channel switching bug, as the codepaths for channel switching have
been touched extensively, probably fixing a major miscalculation issue
("Qdiv roundup" was completely wrong).

So, go ahead, give it a try, and let's rock!

Note that the code in wireless-testing is enough to start testing,
however it's recommended that you apply the following 2 pending fixes:
http://marc.info/?l=linux-wireless&m=125061590101156&w=2 and
http://marc.info/?l=linux-wireless&m=125062611720517&w=2

Tomorrow's compat-wireless tarball, together with the above patches,
should also be good for testing. Not sure about today's tarball.

--Gábor

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
