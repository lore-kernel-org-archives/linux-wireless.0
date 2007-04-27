Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2558 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbXD0CWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 22:22:08 -0400
Date: Thu, 26 Apr 2007 21:46:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-dev wext updates
Message-ID: <20070427014607.GD25332@tuxdriver.com>
References: <1177438546.3528.39.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1177438546.3528.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 24, 2007 at 08:15:46PM +0200, Johannes Berg wrote:
> This patch brings the wext in wireless-dev in line with the wext in
> net-2.6.22 (after the patches I just submitted) and removes the
> cfg80211/wext compat stuff.
> 
> As long as cfg80211 holds the rtnl we'll be able to just hook into
> dev->do_ioctl for the compat code instead.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Johannes,

This didn't apply cleanly to the master branch of the current
wireless-dev.  Could you be sure to pull an up-to-date copy and rediff?

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
