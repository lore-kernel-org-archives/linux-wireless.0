Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59551
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbYAaGUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 01:20:49 -0500
Date: Wed, 30 Jan 2008 22:21:09 -0800 (PST)
Message-Id: <20080130.222109.52073562.davem@davemloft.net> (sfid-20080131_062056_424375_49C22577)
To: jeff@garzik.org
Cc: dlezcano@fr.ibm.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: net-2.6.25 is no more...
From: David Miller <davem@davemloft.net>
In-Reply-To: <47A16611.3000602@garzik.org>
References: <47A03D4D.5090301@fr.ibm.com>
	<20080130.054807.182676684.davem@davemloft.net>
	<47A16611.3000602@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jeff Garzik <jeff@garzik.org>
Date: Thu, 31 Jan 2008 01:09:21 -0500

> David Miller wrote:
> > The latter.
> 
> So...  what to do about changes which are not bug fixes?  Such changes 
> should not go upstream immediately, because that's the standard rule for 
> merge windows.
> 
> And queueing them on our side just re-creates the same old situation we 
> just changed away from, after all.

I'm saying that everything should go to the net-2.6 tree right now.

When the merge window closes, net-2.6 will be for bug fixes only and
I'll hold off on creating net-2.6.26 for about a week so that people
concentrate on regression fixes.

Yes, things will pile up but I think it's appropriate to hold off on
merging features into the 2.6.26 queue for just one week.
