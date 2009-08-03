Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:47392 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbZHCT6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:58:16 -0400
Date: Mon, 3 Aug 2009 21:58:16 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: nico@cam.org
Subject: [PATCH 0/5] various mwl8k bugfixes
Message-ID: <20090803195816.GG18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes a couple of potential crashes and hangs in
mwl8k, and some other misbehaviour.  They are against current linus
tree, which is 2.6.31-rc5 plus some.  Please consider applying.
