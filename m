Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34527 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3KEVAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 16:00:24 -0500
Date: Tue, 5 Nov 2013 15:47:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-10-21
Message-ID: <20131105204733.GC8264@tuxdriver.com> (sfid-20131105_220028_104672_D981010C)
References: <1382360937.14310.49.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382360937.14310.49.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 21, 2013 at 03:08:57PM +0200, Johannes Berg wrote:
> Now with build fixes for !MESH and a channel switch parsing fix.
> 
> In this round for mac80211-next I have:
>  * mesh channel switch support
>  * a CCM rewrite, using potential hardware offloads
>  * SMPS for AP mode
>  * RF-kill GPIO driver updates to make it usable as an ACPI driver
>  * regulatory improvements
>  * documentation fixes
>  * DFS for IBSS mode
>  * and a few small other fixes/improvements
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit 7578d57520f51093f590d68e16965e2714e69747:
> 
>   mac80211: implement STA CSA for drivers using channel contexts (2013-10-02 18:18:23 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to cf867bc30d9af3c2cdbf876224f400a81606eebe:
> 
>   nl80211: fix channel switch parsing (2013-10-21 14:36:56 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
