Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935049Ab3DJJrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 05:47:15 -0400
Message-ID: <1365587230.8388.3.camel@jlt4.sipsolutions.net> (sfid-20130410_114718_358085_C164FCF3)
Subject: Re: [Patch] mac80211: SMPS for AP Mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivekananda Holla <vivekanandah@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 10 Apr 2013 11:47:10 +0200
In-Reply-To: <1365587182.8388.2.camel@jlt4.sipsolutions.net> (sfid-20130410_114635_305806_9CD71018)
References: <516528C8.90509@posedge.com>
	 (sfid-20130410_105443_117821_9F07C071) <1365584151.8388.0.camel@jlt4.sipsolutions.net>
	 <5165326C.7010706@posedge.com>
	 <1365587182.8388.2.camel@jlt4.sipsolutions.net>
	 (sfid-20130410_114635_305806_9CD71018)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 11:46 +0200, Johannes Berg wrote:
> On Wed, 2013-04-10 at 15:05 +0530, Vivekananda Holla wrote:
> > hi Johannes,
> > 
> > do you mean the IEEE80211_TX_RC_USE_RTS_CTS flag to set RTS/CTS
> > protection for the packet?
> > 
> > I did not use this based on the below understanding
> > 
> > my understanding for SMPS is that a station system does not need to
> > send an RTS packet before frame transmission for SMPS however an AP
> > system needs to send out an RTS frame.
> 
> No? Where did you get that idea? It's wrong, it doesn't matter whether
> it's AP or not.

Of course, APs will rarely use SMPS, so stations almost never have to
deal with an AP that uses it ...

johannes

