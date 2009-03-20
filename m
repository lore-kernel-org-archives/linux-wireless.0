Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:35234 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979AbZCTGbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 02:31:18 -0400
To: Adam Baker <linux@baker-net.org.uk>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
In-reply-to: <200903192156.55843.linux@baker-net.org.uk>
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> <200902212123.21950.linux@baker-net.org.uk> <20090308162023.BBD122C40D0@tippex.mynet.homeunix.org> <200903192156.55843.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 20 Mar 2009 07:31:04 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090320063104.92D572C4101@tippex.mynet.homeunix.org> (sfid-20090320_073133_258242_71F16416)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


linux@baker-net.org.uk said:
> Well I can see from those logs that it is only the transmit side that is
> failing, some traffic is being seen on the receive side.

> Does your hardware have an rfkill button and do you have rfkill support
> enabled? I'm wondering if rfkill could be activated by a glitch on the
> signal. 

Rfkill is indeed enabled (for no good reason, really). I'll cook a new one 
without rfkill and see what happens.


linux@baker-net.org.uk said:
>  If trying that approach don't forget to instrument rt2500pci_interrupt as
> well as rt2x00mac_tx

Not knowing anything of the wireless code, I have no idea where to start to 
look. Are these the best functions to start to look in (i.e. sprinkling printf 
in)?

/Anders

