Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45606 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbZLNQVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 11:21:51 -0500
Received: by fxm5 with SMTP id 5so3728301fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 08:21:49 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: Revised wireless tree management practices
Date: Mon, 14 Dec 2009 17:20:11 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200912141516.12224.bzolnier@gmail.com> <200912141559.29282.bzolnier@gmail.com> <20091214.072323.215080360.davem@davemloft.net>
In-Reply-To: <20091214.072323.215080360.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200912141720.11465.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009 04:23:23 pm David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 14 Dec 2009 15:59:29 +0100
> 
> > Hmmm, there are multiple ideas to investigate even within the current
> > "merge window" policy.  Decoupling driver trees from core changes should
> > certainly be possible (it works just fine in the storage area), some
> > architectures make heavy use of topic branches to prevent 'monstermerge'
> > issue etc.
> 
> I don't think seperating drivers out will help.
> 
> I'd say every 5 or core changes we get one that ends up touching some
> API and a hand full of drivers.

Not a problem, driver trees may be based on core tree.

> And this also has implications for testing.  I want the most
> active driver folks have to test their stuff against the core
> changes as well.
> 
> This all happens automatically.

Well, in theory all maintainers should be testing -next kernels
so nothing should change also in this regard.

--
Bartlomiej Zolnierkiewicz
