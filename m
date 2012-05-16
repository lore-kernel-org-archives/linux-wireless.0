Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50525 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab2EPRRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 13:17:49 -0400
Date: Wed, 16 May 2012 13:05:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] iwlwifi fixes
Message-ID: <20120516170535.GB3508@tuxdriver.com> (sfid-20120516_191753_742997_BFC3BD5E)
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 06:05:48PM +0200, Johannes Berg wrote:
> John,
> 
> Here are a few fixes for iwlwifi. It's probably too late to get 
> them into 3.4 but I split them out into their own series anyway.
> 
> This is my first ever submission as iwlwifi maintainer, so I
> hope it works ok and doesn't get too many CCs :-)
> 
> johannes

I didn't think they were suitable for post-rc7.  I tried to apply
them to wireless-next, but they required more rework than I thought
I should be trusted to give them. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
