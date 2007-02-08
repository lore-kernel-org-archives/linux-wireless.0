Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2727 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423250AbXBHTPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 14:15:20 -0500
Date: Thu, 8 Feb 2007 13:50:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] cfg80211: add wext-compatible client
Message-ID: <20070208185050.GA6303@tuxdriver.com>
References: <20070131013717.GA28076@tuxdriver.com> <20070207004626.GA23096@tuxdriver.com> <20070207004747.GB23096@tuxdriver.com> <20070207004832.GC23096@tuxdriver.com> <20070207004929.GD23096@tuxdriver.com> <20070207075420.GB14703@infradead.org> <1170940386.4385.49.camel@johannes.berg> <43e72e890702081038k1d4f226eocf28c5faf6b79dc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890702081038k1d4f226eocf28c5faf6b79dc5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 08, 2007 at 01:38:02PM -0500, Luis R. Rodriguez wrote:
> On 2/8/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> >On Wed, 2007-02-07 at 07:54 +0000, Christoph Hellwig wrote:
> >> Btw, if we submit cfg80211 for inclusion there should be at least one 
> >patch
> >> in the series actually converts a driver to use it.  Both to make this
> >> code not dead and give people and example on how to use the cfg80211
> >> infrastructure.
> >
> >I guess I could make softmac use it.
> 
> Another idea here is we can provide a configfs frontend to cfg80211
> therefore any device which implements cfg80211 will automagically have
> a userspace frontend (/configfs/wireless/foo) ready to test cfg80211.
> With this we wouldn't have to wait for the next userspace nl80211
> application to start testing cfg80211 directly (without wireless
> extensions compat). A configfs frontend can also allow more rapid
> development of userspace interfaces to configure wireless devices
> through cfg80211. Comments?

Luis,

You have mentioned this before, and FWIW I think it is a decent idea.
Let's see some code! :-)

Still, I don't think it changes the issue that we need a driver (or
stack) plugged-in to the bottom end.  I have this on my personal list
of "soon TODO", although I haven't picked a driver yet.

If anyone is working on a cfg80211 driver conversion, please speak-up
so we can avoid duplicating work.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
