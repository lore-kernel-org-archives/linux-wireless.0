Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56303 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3LQTAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 14:00:14 -0500
Date: Tue, 17 Dec 2013 13:56:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2013-12-16
Message-ID: <20131217185652.GB5446@tuxdriver.com> (sfid-20131217_200018_688284_C003270A)
References: <1387205627.2057.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387205627.2057.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 16, 2013 at 03:53:47PM +0100, Johannes Berg wrote:
> John,
> 
> Two more fixes ...
> 
> Here's a fix for another potential radiotap parser buffer overrun thanks
> to Evan Huus, and a fix for a cfg80211 warning in a certain corner case
> (reconnecting to the same BSS).
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit 0834ae3c3af44480834cce128b6fef83006e537f:
> 
>   mac80211: check csa wiphy flag in ibss before switching (2013-12-02 11:54:13 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to bd02cd2549cfcdfc57cb5ce57ffc3feb94f70575:
> 
>   radiotap: fix bitmap-end-finding buffer overrun (2013-12-16 12:06:43 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
