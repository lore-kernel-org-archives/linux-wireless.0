Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45466 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbaJGItM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 04:49:12 -0400
Message-ID: <1412671748.1825.4.camel@jlt4.sipsolutions.net> (sfid-20141007_104915_084982_304F8BE8)
Subject: Re: [RFC] mac80211: enable DFS with channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Oct 2014 10:49:08 +0200
In-Reply-To: <1412232304-7588-1-git-send-email-michal.kazior@tieto.com> (sfid-20141002_085837_358322_FC32805B)
References: <1412232304-7588-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20141002_085837_358322_FC32805B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-02 at 08:45 +0200, Michal Kazior wrote:
> It is okay to enable DFS for channel contexts
> based drivers as long as no combination advertises
> radar detection and multi-channel operation at the
> same time.

Don't we already check the latter in cfg80211?

johannes

