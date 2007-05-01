Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39388 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753089AbXEABAU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2007 21:00:20 -0400
Date: Tue, 1 May 2007 03:00:14 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: "Stable" branch of mac80211
Message-ID: <20070501030014.6523f08a@logostar.upir.cz>
In-Reply-To: <20070429194855.451b9e7c@logostar.upir.cz>
References: <20070429194855.451b9e7c@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Apr 2007 19:48:55 +0200, Jiri Benc wrote:
> I've created a new 'stable' branch in my tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git). It
> contains patches that strip mac80211 down to a stable version. The purpose
> of this branch is to prepare mac80211 for vanilla inclusion.

And preliminary patches targeted for net-2.6 are in
http://kernel.org/pub/linux/kernel/people/jbenc/mac80211/

Please review and test (for testing purposes, a huge patch with all
mac80211 drivers currently in wireless-dev can be found at
http://kernel.org/pub/linux/kernel/people/jbenc/mac80211-test/drivers.patch).

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
