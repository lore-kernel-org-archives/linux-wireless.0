Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966031Ab0BZUd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 15:33:29 -0500
Date: Fri, 26 Feb 2010 12:33:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA errors
In-Reply-To: <201002262120.37438.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002262059.02383.mb@bu3sch.de> <alpine.LFD.2.00.1002261207020.4513@localhost.localdomain> <201002262120.37438.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 26 Feb 2010, Michael Buesch wrote:
> 
> I'd rather appreciate that somebody who owns such a device and can reproduce the bug
> would do some _real_ debugging on the issue instead.

I have the hardware, I can reproduce the bug 100% of the time.

So send me a patch. I'll try it. But I have no hardware docs, nor any 
information about how that SSB bridge is supposed to work, or why DMA 
might be failing.

			Linus
