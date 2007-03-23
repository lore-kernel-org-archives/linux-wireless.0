Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:45840 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934089AbXCWTvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 15:51:45 -0400
Date: Fri, 23 Mar 2007 20:46:27 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: RFC: Future plans for bcm43xx-softmac
Message-ID: <20070323204627.183d2c21@localhost>
In-Reply-To: <4604106F.7080003@lwfinger.net>
References: <4604106F.7080003@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 23 Mar 2007 12:37:51 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> I think we have a plan for the future of bcm43xx-softmac once the
> bcm43xx-mac80211 version goes into mainline. Unfortunately it cannot just
> be abandoned as there will be no support for 802.11b-only devices in
> bcm43xx-mac80211.
> 
> The steps to be done are as follows:
> 
> 1. Change the namespace from bcm43xx to bcm4301. This will both reflect
> the purpose of the changed driver as well as prevent namespace collisions
> with the bcm43xx-mac80211 version in case both are built into the kernel.

I'm quite sure you know, bcm4301 isn't the only 802.11b-only device.
There's bcm4303 too. Anyway, naming the driver bcm4301 sounds reasonable to
me.

> Please comment on this plan.

ACK.


--
Ciao
Stefano
