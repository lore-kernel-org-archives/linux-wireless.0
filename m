Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41239 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYDCOem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 10:34:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: Add PIO support for PCMCIA devices
Date: Thu, 3 Apr 2008 16:33:57 +0200
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200803292101.16696.mb@bu3sch.de> <1207219008.3636.27.camel@johannes.berg>
In-Reply-To: <1207219008.3636.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804031633.57759.mb@bu3sch.de> (sfid-20080403_153445_748993_B0374159)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 April 2008 12:36:48 Johannes Berg wrote:
> 
> > PIO is needed for 16bit PCMCIA devices, as we really don't want to poke with
> > the braindead DMA mechanisms on PCMCIA sockets. Additionally, not all
> > PCMCIA sockets do actually support DMA in 16bit mode (mine doesn't).
> 
> Oddly, my CF card still doesn't work. Is there anything else I need in a
> current wireless-testing tree?

Yeah, see my wireless-testing patches directory. There are still a few
patches that john did not apply, yet.



-- 
Greetings Michael.
