Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47984
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbXISWOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 18:14:50 -0400
Date: Wed, 19 Sep 2007 15:14:46 -0700 (PDT)
Message-Id: <20070919.151446.116351108.davem@davemloft.net>
To: dsd@gentoo.org
Cc: linville@tuxdriver.com, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
Subject: Re: Please pull 'z1211' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <46F19DD0.2050605@gentoo.org>
References: <20070919181005.GB5483@tuxdriver.com>
	<46F19DD0.2050605@gentoo.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Drake <dsd@gentoo.org>
Date: Wed, 19 Sep 2007 23:08:16 +0100

> John, thanks a lot for your efforts, I hope you don't mind waiting one 
> extra release cycle for me to sort a few things out.

Having "a driver" is always better for users than having "no driver".
Please I ask you not to block this merge even if you think it is too
early.

Distribution vendors are going to merge this driver into their kernel
trees anyways.  And as Linus stated at the recent kernel summit, when
this happens and upstream doesn't merge the driver too, the process
has failed.

We have had huge issues with shit piling up in the wireless tree and
it has to stop sooner rather than later, and I'm going to make sure
it stops now.

So please don't feel compelled to fix "all the issues" before a merge.
Drivers will always have issues, and if we merge now you will get more
useful feedback, sooner, and users will have something to use rather
than no driver at all.

Thanks.
