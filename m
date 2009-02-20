Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:36427 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbZBTHrc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 02:47:32 -0500
To: Adam Baker <linux@baker-net.org.uk>
cc: rt2400-devel@lists.sourceforge.net,
	Anders Eriksson <aeriksson@fastmail.fm>,
	linux-wireless@vger.kernel.org
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
In-reply-to: <200902192316.11628.linux@baker-net.org.uk>
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> <200902192316.11628.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 20 Feb 2009 08:47:16 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090220074716.9AB622C4090@tippex.mynet.homeunix.org> (sfid-20090220_084736_937973_71E3E9A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


linux@baker-net.org.uk said:
> The first thing to try would be to see if rmmod rt61pci; modprobe rt61pci is
> enough to recover it. If it is actually a cardbus card then you could also
> try unplugging and replugging it. 

It's a rt2500, so I use that module. Should I use rt61pci?
If memory servers, rmmod/modprobe does not help. It is a PCI card with no loose 
parts on it so unplugging/plugging is not really an option.


linux@baker-net.org.uk said:
> Neither of those is an ideal solution though. Do you fancy the task of trying
>  to diagnose the underlying fault which is likely to require at the very
> least  making sure the driver is built with debugfs support enabled and may
> require  adding a few printk statements into the kernel modules to reveal
> more details  of the behaviour? 

No problem. I've never used debugfs, but I kind of know my way around the 
kernel. The problem has existed at least since the opensource driver got 
merged into mainline. I'm not sure if the closed source one had the same issue.
So bisecting is not really an option.

So, where do I sprinkle the prink's, and what info is useful?

Thanks!
/Anders

