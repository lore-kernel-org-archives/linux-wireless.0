Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55321 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaEFSPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 14:15:11 -0400
Date: Tue, 6 May 2014 14:06:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-05-05
Message-ID: <20140506180647.GE3518@tuxdriver.com> (sfid-20140506_201515_966366_268ED153)
References: <1399297696.22235.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399297696.22235.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 05, 2014 at 03:48:16PM +0200, Johannes Berg wrote:
> John,
> 
> I've been collecting more fixes, but not that much showed up :-)
> 
> Here are a few small fixes for the current cycle: radiotap TX flags were
> wrong (fix by Bob), Chun-Yeow fixes an SMPS issue with mesh interfaces,
> Eliad fixes a locking bug and a cfg80211 state problem and finally
> Henning sent me a fix for IBSS rate information.
> 
> Please let me know if there are any issues.
> 
> Thanks,
> johannes
> 
> The following changes since commit 764152ff66f4a8be1f9d7981e542ffdaa5bd7aff:
> 
>   mac80211: exclude AP_VLAN interfaces from tx power calculation (2014-04-11 09:37:41 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD
> 
> for you to fetch changes up to e669ba2d06c6195662601956454ac959892f0762:
> 
>   mac80211: fix nested rtnl locking on ieee80211_reconfig (2014-05-05 15:14:58 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
