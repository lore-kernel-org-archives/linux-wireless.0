Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46034 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab1EFNZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 09:25:19 -0400
Date: Fri, 6 May 2011 09:19:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	orinoco-users@lists.sourceforge.net,
	orinoco-devel@lists.sourceforge.net, netdev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] wireless: Make and use const struct ieee80211_channel
Message-ID: <20110506131922.GA2252@tuxdriver.com> (sfid-20110506_152539_788898_2A9D3611)
References: <cover.1304054543.git.joe@perches.com>
 <20110505184934.GB3005@tuxdriver.com>
 <1304634107.1788.171.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1304634107.1788.171.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 05, 2011 at 03:21:47PM -0700, Joe Perches wrote:
> On Thu, 2011-05-05 at 14:49 -0400, John W. Linville wrote:
> > These patches generated a lot of warnings in net/mac80211.  Did you
> > actually build them?
> 
> Yes.
> 
> Did you apply patch 1/2 first?
> It's a dependent patch.

That's the one that cause most of the warnings...

-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
