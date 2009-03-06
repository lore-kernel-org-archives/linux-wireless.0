Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25551 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbZCFVf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 16:35:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 13:35:27 -0800
Date: Fri, 6 Mar 2009 13:34:45 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>
Subject: Re: [PATCH v2 0/3] cfg80211: send regulatory events
Message-ID: <20090306213445.GF4336@tesla> (sfid-20090306_223531_125873_13457AC7)
References: <1235690615-12109-1-git-send-email-lrodriguez@atheros.com> <43e72e890902261529k5b31537ctbb6426cd260154a7@mail.gmail.com> <43e72e890902261640j683e6131j7ec922f38874671d@mail.gmail.com> <20090306194243.GF3712@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090306194243.GF3712@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2009 at 11:42:43AM -0800, John W. Linville wrote:
> On Thu, Feb 26, 2009 at 04:40:40PM -0800, Luis R. Rodriguez wrote:
> > On Thu, Feb 26, 2009 at 3:29 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> > > On Thu, Feb 26, 2009 at 3:23 PM, Luis R. Rodriguez
> > > <lrodriguez@atheros.com> wrote:
> > >> This series does the work to prep and then send regulatory
> > >> events to userspace. This v2 keeps the country IE environment
> > >> within cfg80211.h as we don't want to inform userspace about
> > >> details of the country IE. We also now add the defines to help
> > >> userspace determine when the kernel has the new command request
> > >> and attributes.
> > >
> > > I forgot to mention this is also no longer based on top of Jouni's
> > > MLME patch as that will be resent later so this can go in first.
> >
> > Dah -- turns out NL80211_ATTR_REG_INTERSECT is not required as we
> > already pass that on the alpha2. Will resend with that removed. So
> > this now would only add one more attribute, the initiator.
> 
> Did I miss the resend?

Nah sorry, was working on korg bugzilla 12110 [1] which seemd a little more
important than this, but I think today I can get these out, will resend.

  Luis
