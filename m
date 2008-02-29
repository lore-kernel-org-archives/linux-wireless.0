Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34163
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbYB2APZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 19:15:25 -0500
Date: Thu, 28 Feb 2008 16:15:24 -0800 (PST)
Message-Id: <20080228.161524.183616961.davem@davemloft.net> (sfid-20080229_001529_791619_26419A83)
To: gordonfarquharson@gmail.com
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-02-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <97a0a9ac0802281556q2d65ea0fu9f59e02b989fffcf@mail.gmail.com>
References: <97a0a9ac0802281321h6f302865j38a55c6f761dc14b@mail.gmail.com>
	<20080228.133008.228590007.davem@davemloft.net>
	<97a0a9ac0802281556q2d65ea0fu9f59e02b989fffcf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Date: Thu, 28 Feb 2008 16:56:52 -0700

> On Thu, Feb 28, 2008 at 2:30 PM, David Miller <davem@davemloft.net> wrote:
> >  Feel free to push that via Andrew or someone else, but that turd isn't
> >  going in by my tree because to me it's clearly the wrong thing to do.
> 
> Would you support the idea, put forward by Matthieu Castet on LKML, to
> change the test in file2alias such that it issues a warning as opposed
> to an error?

I'm ambivalent, the only constraint is that you cannot
change the layout and alignment of this struct since it
already appeared in 2.6.24 and therefore tools have
been compiled against the existing way it is defined.
