Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58817 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0ALMrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:47:08 -0500
Date: Tue, 12 Jan 2010 13:47:07 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 00/17] more mwl8k updates
Message-ID: <20100112124706.GP1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series, which goes on top of the set I sent earlier, adds
support for (non-DFS) 5 GHz operation, adds multi-BSS AP support (for
8366), and adds support for the 0x2a43 single-band (2.4 GHz only)
88w8366 card.

To keep track of what's outstanding I have pushed a branch consisting
of everything submitted so far (including the previous patch set that
wasn't merged yet) to:

	http://git.marvell.com/?p=mwl8k.git;a=shortlog
	git://git.marvell.com/mwl8k.git
