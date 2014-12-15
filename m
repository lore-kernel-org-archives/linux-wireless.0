Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47496 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaLOBlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 20:41:06 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21646.15533.886900.158792@gargle.gargle.HOWL> (sfid-20141215_024109_952004_5C3D2857)
Date: Mon, 15 Dec 2014 07:13:09 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: New WARNING from mac80211
In-Reply-To: <1418389179.2470.43.camel@sipsolutions.net>
References: <545B8CD1.8020208@lwfinger.net>
	<1415286217.17015.12.camel@sipsolutions.net>
	<21595.38533.767426.846290@gargle.gargle.HOWL>
	<21595.39090.446262.985148@gargle.gargle.HOWL>
	<1418389179.2470.43.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Would it be worthwhile to simply remove the warning and document how we
> can get there?

I think we can fix this by flushing old packets
in sdata->work after a HW scan completes. I'll test this
and post a patch for review.

Sujith
