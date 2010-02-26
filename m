Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966126Ab0BZUuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 15:50:23 -0500
Date: Fri, 26 Feb 2010 12:50:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA  errors
In-Reply-To: <69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002261246330.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>  <4B881C70.9030004@lwfinger.net> <alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>  <alpine.LFD.2.00.1002261205160.4513@localhost.localdomain>
 <69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 26 Feb 2010, Gábor Stefanik wrote:
> 
> Does actually enabling mmiotrace fix it for you too?

I haven't seen the report. What do you need to do? Certainly just enabling 
CONFIG_MMIOTRACE does nothing, but I'd not expect it to - I'd expect that 
you have to actually do the tracing itself.

So if somebody has a recipe for me to test actual tracing of the module, I 
can try to see if it makes a difference for me.

			Linus
