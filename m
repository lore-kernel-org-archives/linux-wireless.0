Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45700
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754310AbXLUEEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 23:04:30 -0500
Date: Thu, 20 Dec 2007 20:04:29 -0800 (PST)
Message-Id: <20071220.200429.242105762.davem@davemloft.net> (sfid-20071221_040434_275901_683EC57F)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071220223850.GL3139@tuxdriver.com>
References: <20071220155321.GF3139@tuxdriver.com>
	<20071220223850.GL3139@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 20 Dec 2007 17:38:50 -0500

> On Thu, Dec 20, 2007 at 10:53:21AM -0500, John W. Linville wrote:
> 
> > These are destined for 2.6.25.  The patches fall mostly into two
> > categories: a new rate control algorithm for mac80211, and some
> > cfg80211 enhancements (including mac80211 patches to use them).
> 
> >       mac80211: make PID rate control algorithm the default
> 
> This patch is busted.  I was mistaken about its readiness --
> I apologize.  Don't pull if you haven't already.
> 
> We are actively working on fixing/replacing it.
> 
> Thanks for your patience!

No worries, let me know when there is a new tree to pull from.
