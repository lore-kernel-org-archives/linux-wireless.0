Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1JTRvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 13:51:48 -0400
Subject: Re: [PATCH 5/6] mac80211: add WMM IE to mesh frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVMUhJ=nV=6N+DpoagKWJxMjythPYMYCCzEb=mTr6TfytQ@mail.gmail.com> (sfid-20111020_194134_871213_05E4800F)
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
	 <1319072606-28291-6-git-send-email-thomas@cozybit.com>
	 <1319109412.3959.7.camel@jlt3.sipsolutions.net>
	 <CAG6hwVMUhJ=nV=6N+DpoagKWJxMjythPYMYCCzEb=mTr6TfytQ@mail.gmail.com>
	 (sfid-20111020_194134_871213_05E4800F)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 19:51:44 +0200
Message-ID: <1319133104.17101.5.camel@jlt3.sipsolutions.net> (sfid-20111020_195150_700913_B5EBEFC9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-20 at 10:41 -0700, Thomas Pedersen wrote:
> On Thu, Oct 20, 2011 at 4:16 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2011-10-19 at 18:03 -0700, Thomas Pedersen wrote:
> >> Include the WMM IE in mesh peering and beacon frames. This is needed
> >> tell any potential peers what our WMM / EDCA parameters are.
> >
> > The goal seems fine but why bother building the WMM IE out of the actual
> > TX queue configuration? Shouldn't it normally be the other way around?
> > But I have no idea how QoS is supposed to work in a mesh...
> 
> I'm not sure what you mean, this is the only way to get the WMM
> parameters? Usually these are just set with ieee80211_set_wmm_defaul()
> on bringing up the interface.

Right, but
 a) if you're using just the default, no need to derive from the default
 b) should they be changeable?

johannes

