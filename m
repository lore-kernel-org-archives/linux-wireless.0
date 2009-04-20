Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56836 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZDTVPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:15:50 -0400
Date: Mon, 20 Apr 2009 17:03:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] mac80211 powersave work
Message-ID: <20090420210342.GH3369@tuxdriver.com> (sfid-20090420_231554_371359_6C168A90)
References: <20090416111723.904720021@sipsolutions.net> <20090420194430.GG3369@tuxdriver.com> <1240257188.4632.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1240257188.4632.19.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2009 at 09:53:08PM +0200, Johannes Berg wrote:
> On Mon, 2009-04-20 at 15:44 -0400, John W. Linville wrote:
> > On Thu, Apr 16, 2009 at 01:17:23PM +0200, Johannes Berg wrote:
> > > This is pretty much unchanged from my previous v2 RFCs,
> > > except that I added a default of 500ms for the dynamic
> > > powersave timer.
> > > 
> > > The fourth patch is new, it adds beacon filtering to
> > > mac80211 -- for the reasons explained in that patch.
> > > 
> > > For 2.6.31, we should make MAC80211_DEFAULT_PS default
> > > off instead. John, how do you want to handle that?
> > 
> > I'm not sure I understand.  Your patch (which would go to 2.6.31)
> > has it turned-on by default.  Which way do you want it?
> 
> I want it turned on by default, at least in wireless-testing; Kalle
> thinks that we should turn it off for a .31 release.
> 
> I would think that since an easy workaround is available ("iwconfig
> wlan0 power off") and it doesn't affect most hardware yet anyway (only
> those supporting powersave) we should turn it on by default anyway,
> since otherwise we won't find any bugs -- but maybe that's just me.

Ah, OK -- let's leave it on for now and if it is a problem we can
turn it off in 2.6.31 during/after 2.6.31-rc1.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
