Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49513 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbZHST5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 15:57:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 12:57:45 -0700
Date: Wed, 19 Aug 2009 12:57:43 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v5 00/33] wireless: kconfig updates
Message-ID: <20090819195743.GB8441@mosca>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
 <20090819150138.GB5905@tuxdriver.com>
 <20090819180235.GA7126@mosca>
 <20090819183506.GG5905@tuxdriver.com>
 <43e72e890908191150h6fa8a811u30c57420afd17e08@mail.gmail.com>
 <20090819185431.GI5905@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090819185431.GI5905@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 11:54:31AM -0700, John W. Linville wrote:
> On Wed, Aug 19, 2009 at 11:50:34AM -0700, Luis R. Rodriguez wrote:
> > On Wed, Aug 19, 2009 at 11:35 AM, John W.
> > Linville<linville@tuxdriver.com> wrote:
> > > On Wed, Aug 19, 2009 at 11:02:35AM -0700, Luis R. Rodriguez wrote:
> > >> On Wed, Aug 19, 2009 at 08:01:38AM -0700, John W. Linville wrote:
> > >
> > >> > I'm sorry, I know you've put some effort into this.  A lot of it seems
> > >> > fine, even welcome.  But I don't really see the point of grouping
> > >> > everything by manufacturer -- it just seems to add an extra level of
> > >> > organization for no particular reason...?
> > >>
> > >> Well at first I didn't really intend to group them by manufacturer really,
> > >> I just tried to get rid of clutter and wanted to group related drivers
> > >> together to make it easier to find for users. After a few iterations the
> > >> manufacturer grouping just happened naturally, and later it also just seemed
> > >> natural to remove the typical postfix "wireless device support" or the like.
> > >>
> > >> I welcome others to try to clean the stuff up some more in a different
> > >> way but I think you may end up with something very similar.
> > >
> > > Can we just drop the "INTEL_80211" and the like, keeping the comments
> > > and basic organization in the Kconfig files as you have them?
> >
> > Well so to group all of Intel stuff we do need this, at least I can't
> > think of a way to do it. If we don't want to group intel stuff then we
> > can remove it. Is there a downside to this grouping, for example?
> 
> Is there an upside to it?

Well sure if you don't want to see any intel driver on that section,
and there are plenlty of Intel wireless drivers.

> Putting them side-by-side in Kconfig
> is fine, but do people really want to (de-)select Intel drivers as
> a group?

Well I do, for instance, just as I expect Intel folks may want to just
disable Atheros drivers when developing, and just as I expect Broadcom
developers to just care about Broadcom drivers, and the same goes for
Ralink.

Intel clutter on the main driver kconfig was really my main motivation
to start this. I understand if you don't see much point to it though.

  Luis
