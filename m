Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33468 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab0A0Tpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 14:45:38 -0500
Date: Wed, 27 Jan 2010 14:44:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, kalle.valo@iki.fi,
	linux-wireless@vger.kernel.org, j@w1.fi, buytenh@wantstofly.org,
	wey-yi.w.guy@intel.com
Subject: Re: [PATCH] mac80211: wait for beacon before enabling powersave
Message-ID: <20100127194418.GJ2962@tuxdriver.com>
References: <1264511993.25642.9.camel@johannes.local> <43e72e891001271001r2cc39da4ka00a3eef06f6e139@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891001271001r2cc39da4ka00a3eef06f6e139@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 10:01:00AM -0800, Luis R. Rodriguez wrote:
> On Tue, Jan 26, 2010 at 5:19 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Because DTIM information is required for powersave
> > but is only conveyed in beacons, wait for a beacon
> > before enabling powersave, and change the way the
> > information is conveyed to the driver accordingly.
> >
> > mwl8k doesn't currently seem to implement PS but
> > requires the DTIM period in a different way; after
> > talking to Lennert we agreed to just have mwl8k do
> > the parsing itself in the finalize_join work.
> 
> Not sure if this is merged yet. If not it might be good to add to the
> commit log a brief about the impact of the fix for distribution
> purposes looking to cherry pick some fixes that may cure some issues.

It's already merged...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
