Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936317Ab0B0WMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 17:12:38 -0500
Date: Sat, 27 Feb 2010 14:12:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA errors
In-Reply-To: <201002272243.27845.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.1002271411120.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002271836.04673.mb@bu3sch.de> <alpine.LFD.2.00.1002271301430.4513@localhost.localdomain> <201002272243.27845.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sat, 27 Feb 2010, Michael Buesch wrote:
> 
> Thanks. What about this? (Remove old patch first).

Doesn't seem to make any difference for me.

		Linus
