Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab2EKJ4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 05:56:38 -0400
Message-ID: <1336730197.4310.17.camel@jlt3.sipsolutions.net> (sfid-20120511_115641_036731_5742EAFC)
Subject: Re: [RFC 2/2] cfg80211: provide channel to start_ap function
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <avinashapatil@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 May 2012 11:56:37 +0200
In-Reply-To: <1336730159.4310.16.camel@jlt3.sipsolutions.net> (sfid-20120511_115606_691270_1D72DE64)
References: <20120510203021.240931880@sipsolutions.net>
	 <20120510203304.806786399@sipsolutions.net>
	 <CAJwzM1=KxQqGRu34C9N-SFcwY3ayVsLnP4BS4iOr7dFgO+qu3A@mail.gmail.com>
	 (sfid-20120511_115153_008299_53B39BF6) <1336730159.4310.16.camel@jlt3.sipsolutions.net>
	 (sfid-20120511_115606_691270_1D72DE64)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-11 at 11:55 +0200, Johannes Berg wrote:
> On Fri, 2012-05-11 at 15:21 +0530, Avinash Patil wrote:
> > Hi Johannes,
> > 
> > Are these patches meant for 3.5?
> > 
> > If so, we will have to modify our AP solution mwifiex AP-STA to set
> > channel in start_ap itself.
> 
> I don't know if they'll still go there since it's really close, but I
> think they can go in soon. I sent them as [PATCH] today.

Btw, this RFC series had a few serious bugs, you don't want to look at
it but the [PATCH] versions from today instead.

johannes

