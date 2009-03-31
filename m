Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:43814 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766AbZCaSSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 14:18:10 -0400
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Adam Baker <linux@baker-net.org.uk>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
In-reply-to: <20090320063104.92D572C4101@tippex.mynet.homeunix.org>
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> <200902212123.21950.linux@baker-net.org.uk> <20090308162023.BBD122C40D0@tippex.mynet.homeunix.org> <200903192156.55843.linux@baker-net.org.uk> <20090320063104.92D572C4101@tippex.mynet.homeunix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 31 Mar 2009 20:17:50 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090331181750.926DE93C47B@tippex.mynet.homeunix.org> (sfid-20090331_201814_609253_8D40B6FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Looking deeper into this I must confess I was wrong here:

aeriksson2@fastmail.fm said:
> Here's another trace of what happens due to lost ProbeResp. The "count" for
> queue 0 stops to increase after that, fwiw. rmmod/modprobe doesn't help. A
> reboot is necessary.

rmmod/modprobe + manually configuring the itnerface DOES seem to fix the 
problem (somehow gentoo's "restart" of the inteface does not. That needs 
further investigation)

I looked at the code, and "No ProbeResp" sits too far from the rt2500pci module 
for me to find out what to do. How is reassociation normally triggered?

/Anders
 


