Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1JTSLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 14:11:42 -0400
Subject: Re: [PATCH 5/6] mac80211: add WMM IE to mesh frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVOaLp9SdPezdw=aLhKrKpPdp8m5vXf6rySTvCfriaziVw@mail.gmail.com> (sfid-20111020_200917_687301_3BF203A5)
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
	 <1319072606-28291-6-git-send-email-thomas@cozybit.com>
	 <1319109412.3959.7.camel@jlt3.sipsolutions.net>
	 <CAG6hwVMUhJ=nV=6N+DpoagKWJxMjythPYMYCCzEb=mTr6TfytQ@mail.gmail.com>
	 <1319133104.17101.5.camel@jlt3.sipsolutions.net>
	 <CAG6hwVMmvu5jMQLeOWG2via0wqkHGs=nHSi_mKvgy9U2+m1FXA@mail.gmail.com>
	 <1319133820.20837.0.camel@jlt3.sipsolutions.net>
	 <CAG6hwVOaLp9SdPezdw=aLhKrKpPdp8m5vXf6rySTvCfriaziVw@mail.gmail.com>
	 (sfid-20111020_200917_687301_3BF203A5)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 20:11:38 +0200
Message-ID: <1319134298.20837.1.camel@jlt3.sipsolutions.net> (sfid-20111020_201145_346835_6A532717)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-20 at 11:08 -0700, Thomas Pedersen wrote:
> On Thu, Oct 20, 2011 at 11:03 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2011-10-20 at 10:56 -0700, Thomas Pedersen wrote:
> >
> >> >> I'm not sure what you mean, this is the only way to get the WMM
> >> >> parameters? Usually these are just set with ieee80211_set_wmm_defaul()
> >> >> on bringing up the interface.
> >> >
> >> > Right, but
> >> >  a) if you're using just the default, no need to derive from the default
> >>
> >> The user might wish to customize the queue parameters though.
> >>
> >> >  b) should they be changeable?
> >>
> >> Why not?
> >
> > Well there no API for it now, is there?
> >
> 
> NL80211_ATTR_WIPHY_TXQ_PARAMS?

Oh, hmm. Ok I guess that's allowed on mesh -- but when it changes you
won't update IEs?

johannes


