Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:50361 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZDMVLc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 17:11:32 -0400
Date: Mon, 13 Apr 2009 21:11:31 +0000
From: George Kadianakis <asn@woodpecker.gentoo.org>
To: linux-wireless@vger.kernel.org
Cc: rt2400-devel@lists.sourceforge.net
Subject: kernel panic with rt61pci
Message-ID: <20090413211131.GA11257@woodpecker.gentoo.org> (sfid-20090413_231138_601198_5ED7E1EC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

this mail is the result of:
http://bugs.gentoo.org/show_bug.cgi?id=262862

The problem is a 2.6.28 regression (which is fixed in 2.6.29) that
causes a kernel panic when rt61pci tries to connect to a router.

You can find a screenshot of the panic over here:
http://bugs.gentoo.org/attachment.cgi?id=185431
For more info, visit the Gentoo bug entry page.

Any ideas on the patch that fixes the crash?

Thanks :)

