Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45401 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZK3RbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:31:10 -0500
Date: Mon, 30 Nov 2009 18:31:16 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 00/11] mwl8k updates
Message-ID: <20091130173116.GP20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of 11 patches goes on top of the fixes I've just sent,
and consists of some more cleanups, and support for 2.4GHz channels
12-14.

Also, it adds support for doing rx ring and other initialization based
on whether the firmware image we've loaded identifies itself as an AP
or a STA image.  In other words, it can now deal at runtime with being
given either type of firmware image.  This makes it possible to add
logic to decide on the fly which type of firmware image to load later
on.

I think it should be safe to apply this set, but if you'd rather wait,
I'll hold them in my local tree for the next window.
