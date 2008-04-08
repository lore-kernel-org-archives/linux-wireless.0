Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b.mail.sonic.net ([64.142.19.5]:36294 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbYDHUoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 16:44:38 -0400
From: Jason Riedy <jason@acm.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Chatre\, Reinette" <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Make IWLCORE a silent option not to confuse iwl3945 users.
References: <874pakhist.fsf@sparse.dyndns.org>
	<D936D925018D154694D8A362EEB0892004195168@orsmsx416.amr.corp.intel.com>
	<20080408180441.GB8183@tuxdriver.com>
Date: Tue, 08 Apr 2008 13:44:18 -0700
In-Reply-To: <20080408180441.GB8183@tuxdriver.com> (John W. Linville's message
	of "Tue, 8 Apr 2008 14:04:41 -0400")
Message-ID: <877if8m5zx.fsf@sparse.dyndns.org> (sfid-20080408_214444_049439_75D2CAC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And John W. Linville writes:
> I think it makes sense to make IWLCORE invisible, but this patch
> seems not quite right.  I'm dropping it -- feel free to repost a
> revised version.

I would love to, but I have no idea what the current base is.
The net-2.6.26 branch of jgarzik/netdev-2.6.git, master of
davem/net-2.6.26.git, and master of your 2.6.26 repo all still
have the iwl3945 that won't compile without iwl4965.  And
rchatre/iwlwifi-2.6.git won't merge into those without irrelevant
conflicts.

This is a mess.  I hope y'all can sort it out before the window
opens.  The blinky lights are fun.

Jason
