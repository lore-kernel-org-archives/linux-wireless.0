Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:38416 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXB1QcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:32:13 -0500
Received: by nf-out-0910.google.com with SMTP id o25so604551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 08:32:11 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
Date: Wed, 28 Feb 2007 17:32:08 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13953.IvDoorn@gmail.com> <1172679612.5015.35.camel@johannes.berg>
In-Reply-To: <1172679612.5015.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281732.08221.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 17:20, Johannes Berg wrote:
> On Wed, 2007-02-28 at 15:07 +0100, Ivo van Doorn wrote:
> 
> > +MODULE_VERSION("CVS");
> 
> Umm, that's just wrong. And it would really help too if you worked the
> other way around, work in wireless-dev (by submitting patches often) and
> maintain old driver versions in CVS.

Well at the moment the cfg80211/nl80211 updates have had a great impact
on our CVS tree. So it is starting to look like we are going to drop our CVS
version if we don't find a backwards compatibility for vanilla kernels for it.

Working the other way around will have a negative (But as mentioned above
a probably unescapable) side effect. 90% of our testers use the CVS against
vanilla kernels, and I cannot see them swicthing to the wireless-dev tree.
So I could switch (it is already under consideration) but it will cost us a lot
of testers.. :(

Anyway, with the updated debugfs patch I'll have the versioning removed.

Ivo
