Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54409
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757513AbZLNPXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 10:23:21 -0500
Date: Mon, 14 Dec 2009 07:23:23 -0800 (PST)
Message-Id: <20091214.072323.215080360.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Revised wireless tree management practices
From: David Miller <davem@davemloft.net>
In-Reply-To: <200912141559.29282.bzolnier@gmail.com>
References: <200912141516.12224.bzolnier@gmail.com>
	<20091214142602.GC18945@tuxdriver.com>
	<200912141559.29282.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 14 Dec 2009 15:59:29 +0100

> Hmmm, there are multiple ideas to investigate even within the current
> "merge window" policy.  Decoupling driver trees from core changes should
> certainly be possible (it works just fine in the storage area), some
> architectures make heavy use of topic branches to prevent 'monstermerge'
> issue etc.

I don't think seperating drivers out will help.

I'd say every 5 or core changes we get one that ends up touching some
API and a hand full of drivers.

And this also has implications for testing.  I want the most
active driver folks have to test their stuff against the core
changes as well.

This all happens automatically.

You can always tell git tools to just give you net/ changes.
