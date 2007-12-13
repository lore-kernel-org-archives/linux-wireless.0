Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3138 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbXLMA7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 19:59:36 -0500
Date: Wed, 12 Dec 2007 19:27:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 ethtool support
Message-ID: <20071213002739.GB3139@tuxdriver.com> (sfid-20071213_005942_352540_C260AA08)
References: <1197361048.3170.381.camel@debian.sh.intel.com> <200712111350.25522.mb@bu3sch.de> <1197421988.3170.405.camel@debian.sh.intel.com> <200712121148.48716.mb@bu3sch.de> <1197481520.6558.140.camel@johannes.berg> <1ba2fa240712121523h59d919f8k42fe54b992618432@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240712121523h59d919f8k42fe54b992618432@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2007 at 01:23:55AM +0200, Tomas Winkler wrote:
> On Dec 12, 2007 7:45 PM, Johannes Berg <johannes@sipsolutions.net> wrote:

> > NACK. Which virtual interface should get this? wmaster sounds like the
> > "obvious" candidate but we want to get rid of it ASAP. And the others
> > ones are pretty wrong because you can, technically, have a wiphy without
> > any virtual interfaces on it.
> >
> Just a thought. What if all virtual interfaces will quasi implements
> it. It doesn't matter if all the interfaces answers the same. Since
> these are get only operations the mutual exclusion shouldn't be so
> hard. All interfaces will support equally the handlers.  But I'm not
> sure about other ethool handlers.
> If wmaster goes will be all virtual interfaces equal citizens ?

Has anyone taken the trouble to analyze the various ethtool operations
to see which ones even make sense for wireless devices?  That might
make a better starting point for discussing how to implement whatever
remains.

John
-- 
John W. Linville
linville@tuxdriver.com
