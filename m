Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1ATTHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 14:07:13 -0500
Subject: Re: Fwd: [Linux Wireless] Update of "en/users/Drivers/carl9170" by
 PaulFertser
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Fertser <fercerpav@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>
In-Reply-To: <20110120185440.GA25136@home.lan>
References: <20110120183210.13527.33808@he.sipsolutions.net>
	 <AANLkTi=EDRimawaentk_ppcrsTf1Rex7H9QJspktaa3C@mail.gmail.com>
	 <20110120184336.GK3333@home.lan>
	 <AANLkTimFGzFgjNWs4QyHuyGixgCiDm_uAb_z4t4m7nD8@mail.gmail.com>
	 <20110120185440.GA25136@home.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 20:07:13 +0100
Message-ID: <1295550433.3693.50.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 21:54 +0300, Paul Fertser wrote:
> On Thu, Jan 20, 2011 at 10:50:43AM -0800, Luis R. Rodriguez wrote:
> > On Thu, Jan 20, 2011 at 10:43 AM, Paul Fertser <fercerpav@gmail.com> wrote:
> > > On Thu, Jan 20, 2011 at 10:37:20AM -0800, Luis R. Rodriguez wrote:
> > >> Huh?
> > >
> > > Christian asked me to add that info to the wiki, is something i wrote wrong?
> > 
> > It is unclear to me, are you saying carl9170 does not support QoS and
> > aggregation?
> 
> At the same time, apparently, yes. This commit[1] has more
> clarifications.
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/chr/carl9170fw.git;a=commitdiff;h=39be7dc384e0dd45dc36b4b517fd9fae874b06f0

It could still do QoS but refuse aggregation sessions on anything but
TID 0 and 1?

johannes

