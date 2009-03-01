Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51902
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbZCAGMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 01:12:47 -0500
Date: Sat, 28 Feb 2009 22:12:29 -0800 (PST)
Message-Id: <20090228.221229.39093473.davem@davemloft.net> (sfid-20090301_071311_188339_FA087831)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-02-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090228.155043.46469864.davem@davemloft.net>
References: <20090227204110.GJ3687@tuxdriver.com>
	<20090228.155043.46469864.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Sat, 28 Feb 2009 15:50:43 -0800 (PST)

> >From git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
>  * branch            master     -> FETCH_HEAD
> fatal: unable to read tree c9ee57c5c20c3b7a2d7784a4172aef8b34c3a844
> davem@sunset:~/src/GIT/net-next-2.6$ git show c9ee57c5c20c3b7a2d7784a4172aef8b34c3a844
> fatal: bad object c9ee57c5c20c3b7a2d7784a4172aef8b34c3a844
> davem@sunset:~/src/GIT/net-next-2.6$ 
 ...
> I wonder if I reverted a push and it contaminated your tree?

It's my local tree which is corrupt, so don't worry about this :-)
