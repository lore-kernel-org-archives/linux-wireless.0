Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:29118 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbXB1TCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 14:02:48 -0500
Received: by nf-out-0910.google.com with SMTP id o25so646142nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 11:02:46 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: split RT2X00 option
Date: Wed, 28 Feb 2007 20:02:42 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281926.38820.IvDoorn@gmail.com> <200702281945.28426.IvDoorn@gmail.com> <1172688802.5015.70.camel@johannes.berg>
In-Reply-To: <1172688802.5015.70.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702282002.42925.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 19:53, Johannes Berg wrote:
> On Wed, 2007-02-28 at 19:45 +0100, Ivo van Doorn wrote:
> 
> > Actually it doesn't fix that problem. :( It remains possible to
> > compile all drivers into the kernel but keeping rt2x00debug.ko as
> > module. But the solution really would be:
> 
> True, I was thinking the other way around somehow.
> 
> > > But couldn't you just  
> > > link the debugfs module into the lib module instead of making it an own
> > > module? I don't see any point in having it separate since there will be
> > > a dependency anyway.
> > 
> > My words exactly. ;)
> > 
> > Merging those 2 modules has been placed on my todo list,
> > I'll try to have this done as soon as possible.
> 
> Yeah, the patch won't be hard to do but needs some file renames so the
> make system copes, and the initialisation hooks. I suppose most people
> actually build either cfg80211 or mac80211 as modules it isn't really a
> big issue right now.
> 
> Btw. Feel free to track things like this on linuxwireless.org somewhere
> around the todo list, maybe someone else picks it up.

Ok, I'll to that within a few days. There are some other points on my todo
list that have to be written down as well. ;)

Ivo
