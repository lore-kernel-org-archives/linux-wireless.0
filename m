Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4403 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYDIAB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 20:01:56 -0400
Date: Tue, 8 Apr 2008 19:38:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jason Riedy <jason@acm.org>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Make IWLCORE a silent option not to confuse iwl3945
	users.
Message-ID: <20080408233858.GA23670@tuxdriver.com> (sfid-20080409_010202_175151_F38FD966)
References: <874pakhist.fsf@sparse.dyndns.org> <D936D925018D154694D8A362EEB0892004195168@orsmsx416.amr.corp.intel.com> <20080408180441.GB8183@tuxdriver.com> <877if8m5zx.fsf@sparse.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <877if8m5zx.fsf@sparse.dyndns.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 08, 2008 at 01:44:18PM -0700, Jason Riedy wrote:
> And John W. Linville writes:
> > I think it makes sense to make IWLCORE invisible, but this patch
> > seems not quite right.  I'm dropping it -- feel free to repost a
> > revised version.
> 
> I would love to, but I have no idea what the current base is.
> The net-2.6.26 branch of jgarzik/netdev-2.6.git, master of
> davem/net-2.6.26.git, and master of your 2.6.26 repo all still
> have the iwl3945 that won't compile without iwl4965.  And
> rchatre/iwlwifi-2.6.git won't merge into those without irrelevant
> conflicts.

Is there some reason you wouldn't use the wireless-testing tree?

> This is a mess.  I hope y'all can sort it out before the window
> opens.  The blinky lights are fun.

Ah, pessimism...so refreshing...

-- 
John W. Linville
linville@tuxdriver.com
