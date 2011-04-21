Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1DUMif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 08:38:35 -0400
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <1303389236.3597.8.camel@jlt3.sipsolutions.net>
References: <20110415045321.GA11504@hertz.marvell.com>
	 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
	 <20110415084005.GC11576@hertz.marvell.com>
	 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
	 <20110415105140.GD11576@hertz.marvell.com>
	 <1302865304.3572.15.camel@jlt3.sipsolutions.net>
	 <20110421121513.GC27527@hertz.marvell.com>
	 <1303389236.3597.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 14:38:31 +0200
Message-ID: <1303389511.3597.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-21 at 14:33 +0200, Johannes Berg wrote:

> So you're putting if (needed_cnt) everywhere because you have
> refcounting bugs? Better fix those bugs ....

Come to think of it, this will be interesting for HW restart code path.
Not sure how to handle that really. Maybe just recompute the counter.

johannes

