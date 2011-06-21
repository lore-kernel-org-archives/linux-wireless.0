Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54386 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab1FUUJt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 16:09:49 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QZ7Gd-0006Qo-R5
	for linux-wireless@vger.kernel.org; Tue, 21 Jun 2011 22:09:47 +0200
Received: from f052160044.adsl.alicedsl.de ([78.52.160.44])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 22:09:47 +0200
Received: from pommnitz by f052160044.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 22:09:47 +0200
To: linux-wireless@vger.kernel.org
From: jpo <pommnitz@yahoo.com>
Subject: Performance regression between Madwifi/net80211 and ath5k/mac80211
Date: Tue, 21 Jun 2011 20:09:37 +0000 (UTC)
Message-ID: <loom.20110621T215346-191@post.gmane.org> (sfid-20110621_220951_882138_F18FA43E)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
there seems to be a significant performance loss when moving from Madwifi 
to ath5k. For an embedded project we have been using Madwifi with Linux kernel
2.6.23. We have tested ath5k for some time and by now it seems to be stable
enough for production use. Unfortunately it doesn't match Madwifi's performance.
Running iperf (both, UDP and TCP) between two machines equipped with an AR5413
with the Fedora 15 kernel and the stock Fedora 15 wireless subsystem shows a
performance loss of about 10% relative to 2.6.23 and Madwifi-0.9.4.
The tests where done under close to ideal lab conditions (cards connected with
an antenna cable) running an IBSS network on channel 40 (5200MHz).

Can anybody confirm this observation?
Is there an explanation?
Are there some tuning knobs I could try to improve the performance with
mac80211/ath5k?
Is the problem outside the wireless subsystem (Maybe it's the TCP/IP stack or
something Fedora specific)?

Thanks in advance.
  Joerg

