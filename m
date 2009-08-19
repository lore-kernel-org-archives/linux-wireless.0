Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43199 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZHSTAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 15:00:10 -0400
Date: Wed, 19 Aug 2009 14:54:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v5 00/33] wireless: kconfig updates
Message-ID: <20090819185431.GI5905@tuxdriver.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com> <20090819150138.GB5905@tuxdriver.com> <20090819180235.GA7126@mosca> <20090819183506.GG5905@tuxdriver.com> <43e72e890908191150h6fa8a811u30c57420afd17e08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890908191150h6fa8a811u30c57420afd17e08@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 11:50:34AM -0700, Luis R. Rodriguez wrote:
> On Wed, Aug 19, 2009 at 11:35 AM, John W.
> Linville<linville@tuxdriver.com> wrote:
> > On Wed, Aug 19, 2009 at 11:02:35AM -0700, Luis R. Rodriguez wrote:
> >> On Wed, Aug 19, 2009 at 08:01:38AM -0700, John W. Linville wrote:
> >
> >> > I'm sorry, I know you've put some effort into this.  A lot of it seems
> >> > fine, even welcome.  But I don't really see the point of grouping
> >> > everything by manufacturer -- it just seems to add an extra level of
> >> > organization for no particular reason...?
> >>
> >> Well at first I didn't really intend to group them by manufacturer really,
> >> I just tried to get rid of clutter and wanted to group related drivers
> >> together to make it easier to find for users. After a few iterations the
> >> manufacturer grouping just happened naturally, and later it also just seemed
> >> natural to remove the typical postfix "wireless device support" or the like.
> >>
> >> I welcome others to try to clean the stuff up some more in a different
> >> way but I think you may end up with something very similar.
> >
> > Can we just drop the "INTEL_80211" and the like, keeping the comments
> > and basic organization in the Kconfig files as you have them?
> 
> Well so to group all of Intel stuff we do need this, at least I can't
> think of a way to do it. If we don't want to group intel stuff then we
> can remove it. Is there a downside to this grouping, for example?

Is there an upside to it?  Putting them side-by-side in Kconfig
is fine, but do people really want to (de-)select Intel drivers as
a group?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
