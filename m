Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:63880 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbXB1Qwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:52:41 -0500
Received: by nf-out-0910.google.com with SMTP id o25so610549nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 08:52:40 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
Date: Wed, 28 Feb 2007 17:52:36 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13953.IvDoorn@gmail.com> <200702281732.08221.IvDoorn@gmail.com> <1172680639.5015.39.camel@johannes.berg>
In-Reply-To: <1172680639.5015.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281752.36875.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Well at the moment the cfg80211/nl80211 updates have had a great impact
> > on our CVS tree. So it is starting to look like we are going to drop our CVS
> > version if we don't find a backwards compatibility for vanilla kernels for it.
> 
> Well, we had to start looking forward somewhere. I wish we'd gotten our
> cfg80211 wext-compat hooks into mainline but unfortunately that isn't
> so.

True, and I was expecting problems like this when I decided to keep supporting
vanilla kernels. But at the moment i am just considering what the best options
for rt2x00 would be.

> > Working the other way around will have a negative (But as mentioned above
> > a probably unescapable) side effect. 90% of our testers use the CVS against
> > vanilla kernels, and I cannot see them swicthing to the wireless-dev tree.
> > So I could switch (it is already under consideration) but it will cost us a lot
> > of testers.. :(
> 
> Intel is providing snapshots for this stuff and I think James is still
> trying to figure out if there's any chance to provide cfg80211 w/o
> patches to mainline, which may just work until critical functionality
> mac80211 is moved over to cfg80211 instead of wext.

I have seen that package, James is as far with backwards compatibility as
we are in rt2x00. But we are apparently hitting against the same problem.
But there is some progress I believe, Robin seems to have managed to
compile cfg80211 now against a 2.6.20 kernel. So we probably need some
research now to add older kernels to the supported list. ;)

Ivo
