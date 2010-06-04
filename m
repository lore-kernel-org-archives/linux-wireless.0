Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:41145 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0FDQ5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 12:57:46 -0400
Date: Fri, 4 Jun 2010 09:56:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 4 (mac80211)
Message-Id: <20100604095651.5f59119e.randy.dunlap@oracle.com>
In-Reply-To: <20100604153006.fa15c770.sfr@canb.auug.org.au>
References: <20100604153006.fa15c770.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 4 Jun 2010 15:30:06 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100603:
> 
> My fixes tree contains:
>       v4l-dvb: update gfp/slab.h includes
>       arm: update gfp/slab.h includes
>       davinci: update gfp/slab.h includes
>       ocfs2: update gfp/slab.h includes
>       acpi: update gfp/slab.h includes
> 
> The wireless tree gained a conflict against the net tree.
> 
> The rr tree gained a build failure for which I applied a patch.


when CONFIG_INET is not enabled:


ERROR: "register_inetaddr_notifier" [net/mac80211/mac80211.ko] undefined!
ERROR: "unregister_inetaddr_notifier" [net/mac80211/mac80211.ko] undefined!

or

(.text+0xb9585): undefined reference to `unregister_inetaddr_notifier'
(.text+0xb9b84): undefined reference to `register_inetaddr_notifier'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
