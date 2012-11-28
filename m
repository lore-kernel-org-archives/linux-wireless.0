Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2K1M5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:57:51 -0500
Message-ID: <1354107495.9345.17.camel@jlt4.sipsolutions.net> (sfid-20121128_135801_244087_CAF5FBC5)
Subject: Re: [RFC] mac80211: add debugfs file for current tx rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 13:58:15 +0100
In-Reply-To: <50B45239.7070300@posedge.com>
References: <3cce329ee6381f0ab4dd4d86ea76c2da@posedge.com>
	 <1353942595.2800.2.camel@jlt4.sipsolutions.net>
	 <50B45239.7070300@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 11:10 +0530, Saravana wrote:
> On 11/26/2012 08:39 PM, Johannes Berg wrote:
> > On Mon, 2012-11-26 at 05:22 -0800, saravanad@posedge.com wrote:
> >> Add a debugfs file showing the current tx rate.
> >> The information available in the rc_stats file
> >> doesn't evidently provides us the current tx rate.
> >> This patch adds the support for the same.
> >
> > I don't see any value in this, you can just do "iw station dump" to get
> > the information.
> >
> The debugfs already contains almost all the parameters that can be 
> viewed  when "iw station dump" is used. e.g. rx/tx bytes,packets, tx 
> retry, power. The current tx rate was available in iw but not in debugfs.
> For sake of completeness and to maintain uniformity, thought of adding
> current tx rate to debugfs.

*shrug*
Ok, fair enough. I guess we can do that.

johannes

