Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYHAHJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 03:09:32 -0400
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, johannes@sipsolutions.net, netdev@axxeo.de,
	Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20080731.212729.138736823.davem@davemloft.net>
References: <20080726.173434.48036095.davem@davemloft.net>
	 <20080727203757.GA2527@ami.dom.local>
	 <20080731.052932.110299354.davem@davemloft.net>
	 <20080731.212729.138736823.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 09:09:24 +0200
Message-Id: <1217574564.8157.111.camel@twins> (sfid-20080801_090936_795081_37E8D423)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-31 at 21:27 -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 31 Jul 2008 05:29:32 -0700 (PDT)
> 
> > It's late here, but I'll start testing the following patch on my
> > multiqueue capable cards after some sleep.
> 
> As a quick followup, I tested this on a machine where I had
> a multiqueue interface and could reproduce the lockdep warnings,
> and the patch makes them go away.
> 
> So I've pushed the patch into net-2.6 and will send it to Linus.

Thanks david!

