Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59765 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757856AbZLNQfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 11:35:08 -0500
Date: Mon, 14 Dec 2009 11:35:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: linux-wireless@vger.kernel.org
Subject: Ethernet bridging with wireless
Message-ID: <Pine.LNX.4.44L0.0912141131190.2685-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just tried to set up ethernet bridging between the wireless interface
and the wired ethernet interface on my laptop machine.  It didn't work.  
As far as I could tell from the tcpdump output, the wireless stack
doesn't want to transmit packets with a foreign link-layer source
address.

Is there any way around this restriction?  Or must I resort to IP 
forwarding instead?

Thanks,

Alan Stern

