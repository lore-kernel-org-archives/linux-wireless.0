Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965792Ab0BZTON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 14:14:13 -0500
Date: Fri, 26 Feb 2010 11:13:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA errors
In-Reply-To: <4B881C70.9030004@lwfinger.net>
Message-ID: <alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <4B881C70.9030004@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 26 Feb 2010, Larry Finger wrote:
> 
> Incidentally, we have learned today that the fault does not occur when running
> MMIO traces, and that it is not SMP related.

Timing? I guess MMIO tracing will slow down the actual command setup part 
a lot.

			Linus
