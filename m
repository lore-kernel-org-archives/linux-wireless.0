Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3613 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbYCZPuT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 11:50:19 -0400
Date: Wed, 26 Mar 2008 11:18:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: silently accept deletion of non-existant key
Message-ID: <20080326151859.GB3457@tuxdriver.com> (sfid-20080326_155024_825474_8865907B)
References: <1206459795-18167-1-git-send-email-linville@tuxdriver.com> <1206462125.16475.303.camel@johannes.berg> <20080325163751.GA19318@tuxdriver.com> <200803251812.45916.mb@bu3sch.de> <20080325173628.GA3026@tuxdriver.com> <1206535674.16475.314.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1206535674.16475.314.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 26, 2008 at 01:47:54PM +0100, Johannes Berg wrote:
> 
> > FWIW, the iwconfig semantic is "disabling encryption", not "deleting
> > the key".  Disabling encryption that is already disabled should be
> > treated as a no-op, not as an error.
> 
> I wish semantics were actually documented ;) I guess you can see it that
> way, feel free to apply the patch based on that.

Just going by the man page...still, I know what you mean! :-)

I'll apply it...thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
