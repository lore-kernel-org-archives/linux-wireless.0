Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab2KWHL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 02:11:28 -0500
Message-ID: <1353654716.10197.0.camel@jlt4.sipsolutions.net> (sfid-20121123_081131_939534_4C9463A1)
Subject: Re: RFC[1/2]mac80211: Add Statistic to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 23 Nov 2012 08:11:56 +0100
In-Reply-To: <50AF1A1E.8090704@posedge.com>
References: <50AF0E91.30709@posedge.com>
	 <CAGRGNgW1x0O26SxytoDQLYXFqWcmfaCGE=Q_pxGg31mW0HyRtw@mail.gmail.com>
	 <50AF1A1E.8090704@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:09 +0530, Saravana wrote:

> > Also, as you're adding new statistics which are only used when debugfs
> > is enabled, you might want to wrap them in #ifdefs so that they're
> > only compiled when debugfs support is compiled.

[...]
> Hence we don't need to wrap this up in #ifdef as it is already taken 
> care during the directory creation.

I think Julian is arguing that you should have the *counters* themselves
be under ifdef, and I tend to agree.

johannes

