Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39928 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab1BLAIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 19:08:19 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Po329-00057t-T2
	for linux-wireless@vger.kernel.org; Sat, 12 Feb 2011 01:08:17 +0100
Received: from f052169174.adsl.alicedsl.de ([78.52.169.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 01:08:17 +0100
Received: from pommnitz by f052169174.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 01:08:17 +0100
To: linux-wireless@vger.kernel.org
From: jpo <pommnitz@yahoo.com>
Subject: Re: WPA for Ethernet?
Date: Sat, 12 Feb 2011 00:08:05 +0000 (UTC)
Message-ID: <loom.20110212T010038-60@post.gmane.org>
References: <loom.20110211T163104-102@post.gmane.org> <20110211162845.GC2224@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville <linville@...> writes:
> I believe wpa_supplicant can do the 802.1x authentication to gain
> access to a port on a supporting switch.  However, I am not aware
> of any standard for "encrypted ethernet" that would build upon that.

John, thanks for taking the time to answer. An untested idea I had was
bridging the mac80211 hwsim device to an ethernet device. Could this work
and would it do what I want? I suspect not, but maybe...
Alternatively, is it somehow possible to connect the lower layer input/output
of hwsim to another network interface? 

> You might consider implementing your own code on top of the TUN/TAP
> driver for point-to-point encrypted links?

How would this differ from OpenVPN?

> John




