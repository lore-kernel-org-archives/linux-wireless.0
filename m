Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42843
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbYHDV65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 17:58:57 -0400
Date: Mon, 04 Aug 2008 14:58:55 -0700 (PDT)
Message-Id: <20080804.145855.230579810.davem@davemloft.net> (sfid-20080804_235914_289686_B3D48E44)
To: marcel@holtmann.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-04
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217886123.7819.23.camel@californication>
References: <1217882288.7819.19.camel@californication>
	<20080804204558.GA5866@tuxdriver.com>
	<1217886123.7819.23.camel@californication>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 04 Aug 2008 23:42:03 +0200

> Hi John,
> 
> > > > Luis R. Rodriguez (4):
> > > >       list.h: Add list_splice_tail() and list_splice_tail_init()
> > > >       list.h: add list_cut_position()
> > > 
> > > have these two changes got reviewed on LKML? I don't see any ACKs for it
> > > in the commit message.
> > 
> > Hmmm...no.  I thought the original patches had been copied to
> > linux-kernel, but it looks like that is not the case.
> > 
> > The original patches are archived here:
> > 
> > 	http://marc.info/?l=linux-wireless&m=121783421908441&w=2
> > 
> > 	http://marc.info/?l=linux-wireless&m=121783422008445&w=2
> > 
> > What problems do you see with them?
> 
> I don't see a problem with these patches, but they should at least be
> reviewed on LKML once. Changes to core kernel infrastructure should not
> be merged silently via subsystem trees without any kind of ACKs.

Right.
