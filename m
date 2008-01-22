Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35240
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbYAVKYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 05:24:30 -0500
Date: Tue, 22 Jan 2008 02:24:37 -0800 (PST)
Message-Id: <20080122.022437.07454007.davem@davemloft.net> (sfid-20080122_102434_146790_6E148843)
To: hs4233@mail.mn-solutions.de
Cc: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
 (2008-01-21)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200801220856.55024.hs4233@mail.mn-solutions.de>
References: <20080121202835.GA3065@tuxdriver.com>
	<200801220856.55024.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 22 Jan 2008 08:56:54 +0100

> > Holger Schurig (5):
> >       libertas cs/sdio: fix 'NOHZ: local_softirq_pending 08'
> 
> This patch was originally from Marc Pignat <marc.pignat@hevs.ch>. 
> Should I have made an "Author: " line into the patch then I 
> re-wrote the patch for wireless-2.6/everything ?

What I usually expect, when it isn't clear, is that the first
"Signed-off-by:" I see is what I use at the author.

That's a pretty reasonable assumption so you might therefore want to
adopt that convention when submitting future patches.
