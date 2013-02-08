Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760233Ab3BHTGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 14:06:05 -0500
Message-ID: <1360350359.29851.27.camel@jlt4.sipsolutions.net> (sfid-20130208_200609_760936_EDDEAC60)
Subject: Re: [PATCH v3 1/2] mac80211: Fix tx queue handling during scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 08 Feb 2013 20:05:59 +0100
In-Reply-To: <20130208181002.GD2622@thinkpad-t410>
References: <1360189829.7910.84.camel@jlt4.sipsolutions.net>
	 <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
	 <1360314212.29851.4.camel@jlt4.sipsolutions.net>
	 <20130208171155.GC2622@thinkpad-t410>
	 <1360343852.29851.26.camel@jlt4.sipsolutions.net>
	 <20130208181002.GD2622@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 12:10 -0600, Seth Forshee wrote:

> Well, I think the way that will be simplest with the fewest code changes
> would be to use a tx control flag. Of course then we've gobbled up one
> of the last available flags.

Let's do that anyway then. I still think we need to do the
PS/scan/offchannel thing I described in another mail anyway, so that'd
be a better interim step than changing all the prototypes...

johannes

