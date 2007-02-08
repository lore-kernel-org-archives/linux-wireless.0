Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37569 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbXBHSWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 13:22:14 -0500
Date: Thu, 8 Feb 2007 19:22:07 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: d80211: Fix TKIP key type
Message-ID: <20070208192207.2781d0d4@griffin.suse.cz>
In-Reply-To: <200702081815.28260.mb@bu3sch.de>
References: <200702031832.48505.mb@bu3sch.de>
	<20070205221957.3c9003b5@griffin.suse.cz>
	<200702061033.50134.flamingice@sourmilk.net>
	<200702081815.28260.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Feb 2007 18:15:27 +0100, Michael Buesch wrote:
> On Tuesday 06 February 2007 16:33, Michael Wu wrote:
> > d80211: Fix TKIP key type
> > 
> > Avoid the messy typecasting and let drivers handle byteordering.
> > 
> > Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> 
> Jiri, can you avoid pulling this patch, yet?
> I am trying to get a better solution for the whole TKIP stuff
> that actually works with bcm43xx. My patch will fix this issue then, too.

I wasn't going to apply it anyway as it doesn't seem to solve the
problem - it just shifts it to someone else.

 Jiri

-- 
Jiri Benc
SUSE Labs
