Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:39308 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZHXNmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 09:42:22 -0400
Date: Mon, 24 Aug 2009 15:42:22 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mwl8k: three bug fixes, and a cosmetic fix
Message-ID: <20090824134222.GB6102@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some more patches for wireless-testing:
- A bug fix to fix an inverted error test in mwl8k_bss_info_changed().
  This was accidentally introduced in the last batch of changes.
- Two minor bug fixes for issues that exist in 2.6.31 as well, but
  aren't really important enough to justify applying there.
- A cosmetic fix to clarify the difference between driver and device
  info during probe.
