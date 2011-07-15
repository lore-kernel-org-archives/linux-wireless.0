Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1GOSlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 14:41:53 -0400
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVP4pGonXgJwoRYgG0yRgPXZVOR54PvcC2-oCkMPWu14eQ@mail.gmail.com> (sfid-20110715_203716_491536_646B3EE1)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-2-git-send-email-thomas@cozybit.com>
	 <1310723140.4164.10.camel@jlt3.sipsolutions.net>
	 <CAG6hwVP4pGonXgJwoRYgG0yRgPXZVOR54PvcC2-oCkMPWu14eQ@mail.gmail.com>
	 (sfid-20110715_203716_491536_646B3EE1)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 20:41:50 +0200
Message-ID: <1310755310.4164.26.camel@jlt3.sipsolutions.net> (sfid-20110715_204156_486196_4661CD4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-07-15 at 11:36 -0700, Thomas Pedersen wrote:
> On Fri, Jul 15, 2011 at 2:45 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
> >
> >> Based on Javier Cardona's "mac80211: Support beacon configuration via
> >> nl80211 for mesh interfaces", which never made it upstream.
> >
> > Ok I don't get it -- this patchset seems to apply fine, so what part is
> > dependent on Javier's patches?
> 
> "derived from" would have been much more accurate wording.

Oh, I misunderstood, thanks.

johannes

