Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42026 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753346AbXGJNfP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 09:35:15 -0400
Date: Tue, 10 Jul 2007 15:34:56 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
Message-ID: <20070710153456.471e395e@logostar.upir.cz>
In-Reply-To: <20070621221603.778432000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Jun 2007 00:16:03 +0200, Johannes Berg wrote:
> ieee80211.c is just too large to be maintainable. This patch series
> splits it up into a few smaller files; it also has a few tiny
> buglet-fixes.

I agree. And I like these patches, they make sense.

But: It would make putting changes currently in wireless-dev to upstream a
nightmare. I wouldn't be able to take patches in the form they were
committed anymore and would need to heavily modify them.

Sorry, NAK for now. Let's do that after mac80211 is completely upstream.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
