Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59162 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3HBTpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 15:45:13 -0400
Date: Fri, 2 Aug 2013 15:38:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-07-26
Message-ID: <20130802193821.GD10800@tuxdriver.com> (sfid-20130802_214522_173000_6F7A5271)
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 10:28:17AM +0200, Johannes Berg wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> John,
> 
> First -next pull request for iwlwifi. I'm trying something new, writing
> the pull request directly into the cover letter of git send-email so I
> can send the patches out at the same time as the pull request and don't
> forget the patches - let me know if there's a problem with that.
> 
> There are a lot of various changes, I can't really list them all in a
> meaningful way. One thing to note is maybe that we're removing the P2P
> support from the older driver - it has never been really functional and
> should be converted to P2P-Device, but we don't have time or testing
> support to do that, and as it is it's not really functional.
> 
> 
> johannes
> 
> 
> The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:
> 
>   Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 5e216eb4ed04b9b1725ce3e7779a4fb680e63446:
> 
>   iwlwifi: mvm: add high temperature SKU thermal throttling parameters (2013-07-26 10:21:14 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
