Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35059
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbZH2GF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 02:05:28 -0400
Date: Fri, 28 Aug 2009 23:05:42 -0700 (PDT)
Message-Id: <20090828.230542.249636196.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090828191039.GC32694@tuxdriver.com>
References: <20090828191039.GC32694@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 15:10:39 -0400

> Dave,
> 
> One more late-breaker for 2.6.31...
> 
> This patch is rather large for this stage of the cycle, but it
> corrects a regression disussed recently on LKML, documented in bug
> 14016 at bugzilla.kernel.org.  This jist of it is that the ipw2200
> firmware loading routine was using an order 6 memory allocation that was
> failing with newer allocators under some circumstances.

Pulled, thanks.
