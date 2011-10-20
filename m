Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1JTSWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 14:22:09 -0400
Subject: Re: [PATCH 5/6] mac80211: add WMM IE to mesh frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVNsLR0Ts1izDea8zJ8nw9FvM4c0n=nNCr0TBBQaUbkk=g@mail.gmail.com> (sfid-20111020_201506_495059_BA6684E4)
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
	 <1319072606-28291-6-git-send-email-thomas@cozybit.com>
	 <1319109412.3959.7.camel@jlt3.sipsolutions.net>
	 <CAG6hwVMUhJ=nV=6N+DpoagKWJxMjythPYMYCCzEb=mTr6TfytQ@mail.gmail.com>
	 <1319133104.17101.5.camel@jlt3.sipsolutions.net>
	 <CAG6hwVMmvu5jMQLeOWG2via0wqkHGs=nHSi_mKvgy9U2+m1FXA@mail.gmail.com>
	 <1319133820.20837.0.camel@jlt3.sipsolutions.net>
	 <CAG6hwVOaLp9SdPezdw=aLhKrKpPdp8m5vXf6rySTvCfriaziVw@mail.gmail.com>
	 <1319134298.20837.1.camel@jlt3.sipsolutions.net>
	 <CAG6hwVNsLR0Ts1izDea8zJ8nw9FvM4c0n=nNCr0TBBQaUbkk=g@mail.gmail.com>
	 (sfid-20111020_201506_495059_BA6684E4)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 20:22:05 +0200
Message-ID: <1319134925.20837.2.camel@jlt3.sipsolutions.net> (sfid-20111020_202217_376198_0827320A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-20 at 11:14 -0700, Thomas Pedersen wrote:

> > Oh, hmm. Ok I guess that's allowed on mesh -- but when it changes you
> > won't update IEs?
> >
> 
> We reconstruct IEs on every beacon_get() (I know...), so it should be OK.

Yeah I guess it's ok at least for now.

Changing the parameters while active would cause all kinds of problems
though since you don't peer if they differ?

Anyway, no big deal. Let's keep it this way.

johannes

