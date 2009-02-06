Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eta-ori.net ([91.121.142.51]:42220 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZBFXHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 18:07:48 -0500
Received: from [IPv6:2001:6f8:10ae:0:217:31ff:fe81:8c8] (istari.kleinerfeigling.org [IPv6:2001:6f8:10ae:0:217:31ff:fe81:8c8])
	by orion.eta-ori.net (Postfix) with ESMTPSA id 0248E317A26
	for <linux-wireless@vger.kernel.org>; Fri,  6 Feb 2009 23:57:46 +0100 (CET)
Message-ID: <498CC07F.3080800@impulze.org> (sfid-20090207_000752_106845_DB46FE2D)
Date: Fri, 06 Feb 2009 23:58:07 +0100
From: Daniel Mierswa <impulze@impulze.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: location of binaries and libraries of new wifi tools
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey list, I was wondering where to put binaries for the new
wireless-stack based tools. Most default installations put libnl, crypto
and gcrypt into /usr. Applications like iw, wpa_supplicant and crda need
those to run, yet they do not link statically. So if the default
location for the new binaries is /sbin or /bin and the libraries it
links against are default installed somewhere into /usr things will
break. I wonder now what to do for consistency. Either statically link
libraries that are default installed into /usr, put those libs into /lib
or install the binaries into /usr aswell. I'd appreciate any comments on
that. :) Thanks and have a nice weekend.

-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22
