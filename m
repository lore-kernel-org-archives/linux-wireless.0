Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:44783 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbXI0QRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 12:17:34 -0400
Message-ID: <3072.194.45.26.221.1190909853.squirrel@webmail.madwifi.org>
Date: Thu, 27 Sep 2007 18:17:33 +0200 (CEST)
Subject: SFLC helps ath5k developers contribute back to OpenBSD
From: "Michael Renzmann" <mrenzmann@madwifi.org>
To: madwifi-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SFLC today released what we hope will be the last audit of driver code for
use in the Linux kernel for Atheros WLAN devices. Specifically this should
once and for all clear up any doubts about licensing practices we have
used and details of provenance of code since the project's start all the
way down to our current ath5k driver code.

The audit confirms that fixes and improvements to work derived from
OpenBSD's ar5k - specificially what is in the wireless-legacy respository
[1] now - can safely be contributed back. We are committing to follow
SFLC's advise on proper procedures to guarantee that contributing back to
OpenBSD remains possible in the future.

In all there are three new documents published by the SFLC:

 1. Code Analysis of the Linux Wireless Team's ath5k Driver [2]
 2. Maintaining Permissive-Licensed Files in a GPL-Licensed Project:
Guidelines for Developers [3]
 3. Originality Requirements under U.S. and E.U. Copyright Law [4]

We would like to take the time to thank the SFLC for their hard work and
restless dedication. It should be made clear that without the SFLC the
ath5k driver would simply have not be possible. Please consider donating
to the SFLC [5].

---

Links:
[1]
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-legacy.git;a=commit;h=c1928199c27de433d1e81b78e3178be4f0e978d2
[2] http://www.softwarefreedom.org/resources/2007/ath5k-code-analysis.html
[3]
http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html
[4]
http://www.softwarefreedom.org/resources/2007/originality-requirements.html
[5] http://www.softwarefreedom.org/about/donate/

