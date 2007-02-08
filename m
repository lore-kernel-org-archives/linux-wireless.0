Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.239]:59953 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423269AbXBHTlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 14:41:49 -0500
Received: by nz-out-0506.google.com with SMTP id s1so573240nze
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2007 11:41:49 -0800 (PST)
Message-ID: <43e72e890702081141j168da47i421f4fe578a08735@mail.gmail.com>
Date: Thu, 8 Feb 2007 14:41:48 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC PATCH 3/3] cfg80211: add wext-compatible client
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Christoph Hellwig" <hch@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070208185050.GA6303@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <20070131013717.GA28076@tuxdriver.com>
	 <20070207004626.GA23096@tuxdriver.com>
	 <20070207004747.GB23096@tuxdriver.com>
	 <20070207004832.GC23096@tuxdriver.com>
	 <20070207004929.GD23096@tuxdriver.com>
	 <20070207075420.GB14703@infradead.org>
	 <1170940386.4385.49.camel@johannes.berg>
	 <43e72e890702081038k1d4f226eocf28c5faf6b79dc5@mail.gmail.com>
	 <20070208185050.GA6303@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/8/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Feb 08, 2007 at 01:38:02PM -0500, Luis R. Rodriguez wrote:
> > On 2/8/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >On Wed, 2007-02-07 at 07:54 +0000, Christoph Hellwig wrote:
> > >> Btw, if we submit cfg80211 for inclusion there should be at least one
> > >patch
> > >> in the series actually converts a driver to use it.  Both to make this
> > >> code not dead and give people and example on how to use the cfg80211
> > >> infrastructure.
> > >
> > >I guess I could make softmac use it.
> >
> > Another idea here is we can provide a configfs frontend to cfg80211
> > therefore any device which implements cfg80211 will automagically have
> > a userspace frontend (/configfs/wireless/foo) ready to test cfg80211.
> > With this we wouldn't have to wait for the next userspace nl80211
> > application to start testing cfg80211 directly (without wireless
> > extensions compat). A configfs frontend can also allow more rapid
> > development of userspace interfaces to configure wireless devices
> > through cfg80211. Comments?
>
> Luis,
>
> You have mentioned this before, and FWIW I think it is a decent idea.
> Let's see some code! :-)

I know, I know, talk is cheap, trust me, I abide by this motto every
day. I actually wanted to just code this up and send this as part of
my comment but do have other responsibilities I have to attend to
first. I figured I'd throw it out though in case someone who does have
time is willing to pick it up as I think it would be great for us.

> Still, I don't think it changes the issue that we need a driver (or
> stack) plugged-in to the bottom end.  I have this on my personal list
> of "soon TODO", although I haven't picked a driver yet.
>
> If anyone is working on a cfg80211 driver conversion, please speak-up
> so we can avoid duplicating work.

  Luis
