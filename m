Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:34307 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbXJZPqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 11:46:33 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IlROK-0000Wa-Nt
	for linux-wireless@vger.kernel.org; Fri, 26 Oct 2007 11:46:32 -0400
Subject: Re: [FYI] hostapd state with mac80211 on linux
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chuck Tuffli <CTuffli@dspg.com>, hostap <hostap@shmoo.com>,
	Alexander Kotelnikov <sacha@myxomop.com>
In-Reply-To: <1193338400.4406.4.camel@johannes.berg>
References: <1193338400.4406.4.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 11:46:28 -0400
Message-Id: <1193413588.2026.6.camel@dv> (sfid-20071026_164636_511884_02C351FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-10-25 at 20:53 +0200, Johannes Berg wrote:
> Since more and more people seem to be interested in it, here's a quick
> status update:
> 
> hostapd works with
>  - kernel 2.6.24-rc1
>  - plus my patches from http://johannes.sipsolutions.net/patches/kernel/all/
>  - plus the commit 5c58298c2536252ab95aa2b1497ab47eb878ca5d from net-2.6
>    ([NETLINK]: Fix ACK processing after netlink_dump_start)

Great, thank you!  Can we have all the above in one place in a publicly
available git repository, please?

>  - my hostapd patches from http://johannes.sipsolutions.net/patches/hostap/all/

And this too, if possible.  Maybe we could have this in hostap master
branch?  All patches except 004 affect the devicescape driver only, and
004 looks benign to me.

-- 
Regards,
Pavel Roskin

