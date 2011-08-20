Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58369 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab1HTTUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 15:20:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qur5S-0004G1-5a
	for linux-wireless@vger.kernel.org; Sat, 20 Aug 2011 21:20:06 +0200
Received: from 69-196-174-66.dsl.teksavvy.com ([69.196.174.66])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 20 Aug 2011 21:20:06 +0200
Received: from dennisn by 69-196-174-66.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 20 Aug 2011 21:20:06 +0200
To: linux-wireless@vger.kernel.org
From: Dennis Nezic <dennisn@dennisn.dyndns.org>
Subject: Vague wifi fail with ipw2200
Date: Sat, 20 Aug 2011 15:14:02 -0400
Message-ID: <20110820151402.605226e7.dennisn@dennisn.dyndns.org> (sfid-20110820_212011_387524_03EBDFB2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For that last long while, I have been having strange vague wifi fails
every few days -- my ipw2200 ad-hoc server would suddenly become very
unresponsive -- instead of the usual stable 0.6ms pings, they would
fluctuate wildly from a minimum of about 2ms to 10ms, even though the
connection wasn't being used. More seriously/substantially, iwconfig
would show the "Tx excessive retries" to be steadily increasing -- and
drastically increasing with more usage -- 10-100 retries per second
under heavy usage. I have tried playing with the "Retry limit" "RTS thr"
and "Fragrment thr" values a bit, and with a fixed bitrate, but they
didn't seem to have any significant effect -- the connection would still
inevitably reach this turbulence and ultimately fail, forcing me to
restart it.

I don't think it's simply a noisy environment, although there are about
10 other access points around here, none of which shares my channel 1
at the moment. (There's one on 2, one on 3.) Because that wouldn't
explain why the connection becomes stable and fast after I restart the
wifi interface.

I'm guessing it's something to do with the driver?

