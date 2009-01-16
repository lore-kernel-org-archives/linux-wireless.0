Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20303 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbZAPVCd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 16:02:33 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 13:02:33 -0800
Date: Fri, 16 Jan 2009 13:02:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 10/13] cfg80211: remove check for last_request on
	ignore_reg_update()
Message-ID: <20090116210204.GJ29609@tesla> (sfid-20090116_220240_784129_A6C158DE)
References: <1232064746-17134-5-git-send-email-lrodriguez@atheros.com> <1232064746-17134-6-git-send-email-lrodriguez@atheros.com> <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232064746-17134-9-git-send-email-lrodriguez@atheros.com> <1232064746-17134-10-git-send-email-lrodriguez@atheros.com> <1232064746-17134-11-git-send-email-lrodriguez@atheros.com> <1232097990.3854.31.camel@johannes> <20090116162731.GD29609@tesla> <1232137980.3745.3.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232137980.3745.3.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 12:33:00PM -0800, Johannes Berg wrote:
> On Fri, 2009-01-16 at 08:27 -0800, Luis R. Rodriguez wrote:
> > On Fri, Jan 16, 2009 at 01:26:30AM -0800, Johannes Berg wrote:
> > > On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > > > There is no need to check for last_request as the callers of
> > > > update_all_wiphy_regulatory() ensure its present.
> > > 
> > > Are you sure? I had all this blow up all around me.
> > 
> > Interesting -- well that's the thing, where and why would it have blown up?
> > I did test it and didn't run into it.
> 
> Only w/o crda and old-regulatory did I see that happen though, not sure.

Bleh -- I suppose I'll have to retest this series with OLD_REG enabled after all...

  Luis
