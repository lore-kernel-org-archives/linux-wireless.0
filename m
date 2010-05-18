Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33348 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab0ERRPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 13:15:10 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1OEQNp-0005lu-Jj
	for linux-wireless@vger.kernel.org; Tue, 18 May 2010 13:15:09 -0400
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id o4IHBrff014622
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 13:11:53 -0400
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id o4IHBr68014621
	for linux-wireless@vger.kernel.org; Tue, 18 May 2010 13:11:53 -0400
Date: Tue, 18 May 2010 13:11:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: merge window -- [davem@davemloft.net: bug fixes only please...]
Message-ID: <20100518171152.GE4190@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI...expect delays for any patches posted between now and -rc1.
I also have a backlog from the weekend, which seemed unusually active.
I'll evaluate those already in the queue for inclusion in 2.6.35,
but no promises....

John

----- Forwarded message from David Miller <davem@davemloft.net> -----

> Date: Mon, 17 May 2010 22:25:49 -0700 (PDT)
> From: David Miller <davem@davemloft.net>
> To: netdev@vger.kernel.org
> Subject: bug fixes only please...
> X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
> 
> 
> We are entering the merge window, so please do not submit any new
> features or cleanups at this time.
> 
> I will make a final pass through patchwork before I submit to Linus
> so anything there still has a chance.  I also plan to merge the
> respun virtif netlink bits, as that code was ready it's just that
> a change that went into net-2.6 the other day created conflicts.
> 
> We'll open the spigot back up after 2.6.35-rc1 goes out.
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

----- End forwarded message -----

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
