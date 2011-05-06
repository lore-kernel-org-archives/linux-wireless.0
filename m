Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1288 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab1EFQKX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 12:10:23 -0400
Subject: Re: [PATCH 0/2] wireless: Make and use const struct
 ieee80211_channel
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	orinoco-users@lists.sourceforge.net,
	orinoco-devel@lists.sourceforge.net, netdev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110506131922.GA2252@tuxdriver.com>
References: <cover.1304054543.git.joe@perches.com>
	 <20110505184934.GB3005@tuxdriver.com>
	 <1304634107.1788.171.camel@Joe-Laptop>
	 <20110506131922.GA2252@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 09:10:21 -0700
Message-ID: <1304698221.11874.6.camel@Joe-Laptop> (sfid-20110506_181047_518696_850A0E33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-06 at 09:19 -0400, John W. Linville wrote:
> On Thu, May 05, 2011 at 03:21:47PM -0700, Joe Perches wrote:
> > On Thu, 2011-05-05 at 14:49 -0400, John W. Linville wrote:
> > > These patches generated a lot of warnings in net/mac80211.  Did you
> > > actually build them?
> > Yes.
> > Did you apply patch 1/2 first?
> > It's a dependent patch.
> That's the one that cause most of the warnings...

Consider the 2 patches as a single patch.
Do you have new build warnings after applying both
patches 1 and 2?

