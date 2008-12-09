Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pqueuea.post.tele.dk ([193.162.153.9]:38903 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbYLIMMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 07:12:39 -0500
Received: from pfepb.post.tele.dk (pfepb.post.tele.dk [195.41.46.236])
	by pqueuea.post.tele.dk (Postfix) with ESMTP id 5FA84DC0AB
	for <linux-wireless@vger.kernel.org>; Tue,  9 Dec 2008 13:12:35 +0100 (CET)
Date: Tue, 9 Dec 2008 13:12:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211/cfg80211: check endianness in sparse runs
Message-ID: <20081209121231.GA3578@uranus.ravnborg.org> (sfid-20081209_131243_731654_C9251A4E)
References: <1228822793.22164.210.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228822793.22164.210.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 09, 2008 at 12:39:52PM +0100, Johannes Berg wrote:
> Make sure sparse checks endianness when run on mac80211/cfg80211.
> 

How far are we from being able to do this kernel wide?
Some effort has been put into lower the noise level I think.

So I prefer to see it generally enabled but if this is too soon
then I'm fine with this patch.

	Sam
