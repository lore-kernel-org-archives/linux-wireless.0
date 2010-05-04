Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53271 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab0EDUUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 16:20:02 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 13:20:02 -0700
Date: Tue, 4 May 2010 13:20:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Javier Cardona <javier@cozybit.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Mathieu Olivari <Mathieu.Olivari@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211/ath9k: HT rates in Mesh
Message-ID: <20100504202000.GK2624@tux>
References: <93781E992CBA7843962D8B0E7D683F3C1116C465A6@SC1EXMB-MBCL.global.atheros.com>
 <20100504194348.GD2624@tux>
 <93781E992CBA7843962D8B0E7D683F3C1116C465EA@SC1EXMB-MBCL.global.atheros.com>
 <20100504195211.GG2624@tux>
 <1273004047.3673.26.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1273004047.3673.26.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding Javier.

On Tue, May 04, 2010 at 01:14:07PM -0700, Johannes Berg wrote:
> On Tue, 2010-05-04 at 12:52 -0700, Luis R. Rodriguez wrote:
> > Cc'ing linux-wireless.
> > 
> > On Tue, May 04, 2010 at 12:45:36PM -0700, Mathieu Olivari wrote:
> > > BTW, do you know if HT is supported in Mesh ?
> > 
> > This would involve doing the same as for IBSS that Benoit
> > is doing, someone with good will would have to do it. It should
> > be fairly easy to review the patches implemented by Benoit to
> > port to Mesh but there may be some unresolved things I may be
> > overlooking.
> 
> Last I heard mesh wasn't supporting HT at all due to whatever issues?
> Maybe protection or something?

Oh .. yeah... it was aggregation that was not allowed. So the only
other change you'd have to do is to disable aggregation IIRC unless
something else has changed on the latest 11s drafts.

  Luis
