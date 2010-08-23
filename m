Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0HWLCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 07:02:47 -0400
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat Linux))
	id 1OnUnf-00020L-7o
	for linux-wireless@vger.kernel.org; Mon, 23 Aug 2010 11:02:47 +0000
Date: Mon, 23 Aug 2010 07:02:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: linux-wireless@vger.kernel.org
Subject: iwlagn fails to associate on 2.6.36-rc2
Message-ID: <20100823110247.GA3198@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just tried to boot into 2.6.36-rc2 and now the Intel 5100 controller
in my Thinkpad T500 fails to associate with my cheap Netgear access
point.  Note that this is the same setup that already has problems
staying associated for a few kernel releases unless I keep a background
ping running.

Any good way to debug this?  There haven't been any interesting messages
in the kernel log.
