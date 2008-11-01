Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52027 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbYKAWfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 18:35:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KwP3e-0001lA-QS
	for linux-wireless@vger.kernel.org; Sat, 01 Nov 2008 22:35:02 +0000
Received: from ppp-88-217-21-212.dynamic.mnet-online.de ([88.217.21.212])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 22:35:02 +0000
Received: from berni by ppp-88-217-21-212.dynamic.mnet-online.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 22:35:02 +0000
To: linux-wireless@vger.kernel.org
From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Forcing/Forbidding specific band on iwlagn
Date: Sat, 1 Nov 2008 22:30:03 +0000 (UTC)
Message-ID: <geil9a$jdt$1@ger.gmane.org> (sfid-20081101_233511_513363_417D4DE9)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a rather user-side question, I don't know exactly whether I'm
right in here :-)

I have a Dell Latitude D630 with an Intel IWL4965AGN wireless card
running Ubuntu 8.10 amd64 (Linux 2.6.27 -> iwlagn). It is pretty flaky
and crashes my system at least once a day (when something happens with
my wireless), but that will be the subject of another debugging session.

I'm usually operating in the environment of my university where about
90% of our access points are Colubris MAP-320 (11g only), 5% are
Colubris MAP-330 (11a+11g dualradio) and 5% are Colubris MAP-625
(11a/n+11g dualradio). Unfortunately, even when sitting pretty close to
a MAP-625 my system usually connects to the 11g radio (probably because
of the slightly better RF distribution of 2.4GHz). I'm not even exactly
sure what's selecting the channel, I guess wpa_supplicant?

Are there any ways to force the card to 5GHz only (or even 11n only) for
scanning and connection purpose? I think my old Atheros-based dualband
card provided a knob for this using iwpriv, but I couldn't find anything
for iwlagn and I would have expected something more general.

Thanks,
Bernhard

