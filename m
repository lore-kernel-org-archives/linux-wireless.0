Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44959
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754878AbYGHXof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 19:44:35 -0400
Date: Tue, 08 Jul 2008 16:44:35 -0700 (PDT)
Message-Id: <20080708.164435.141370914.davem@davemloft.net> (sfid-20080709_014438_476068_EC1A9CBA)
To: sfr@canb.auug.org.au
Cc: linville@tuxdriver.com, linux-next@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: pending wireless/wireless-current merge conflict
 2008-07-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080709094037.8e3050d9.sfr@canb.auug.org.au>
References: <20080702220212.GA31582@tuxdriver.com>
	<20080708203044.GA6381@tuxdriver.com>
	<20080709094037.8e3050d9.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 9 Jul 2008 09:40:37 +1000

> Hi John,
> 
> On Tue, 8 Jul 2008 16:30:44 -0400 "John W. Linville" <linville@tuxdriver.com> wrote:
> >
> > I just sent a pull request for Dave that will result in a merge
> > conflict in linux-next.  I have a sample merge available here:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6 merge-test
> > 
> > Just a heads-up... :-)
> > 
> > John
> > 
> > P.S.  These are one-liners (including the one from yesterday).
> > Nevertheless, it can't hurt to provide a reference "just in
> > case"... :-)
> 
> Appreciated, thanks.

I just merged net-2.6 into net-next-2.6 and sorted all of the
merge issues out, so I hope you won't bump into anything :)
