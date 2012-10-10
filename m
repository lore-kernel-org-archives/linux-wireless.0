Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44288 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2JJF3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 01:29:48 -0400
Message-ID: <1349847023.4683.25.camel@jlt4.sipsolutions.net> (sfid-20121010_072959_704079_7B4C2832)
Subject: Re: [RFC] mac80211: make powersave independent of interface type
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 Oct 2012 07:30:23 +0200
In-Reply-To: <5074886E.1040400@etit.tu-chemnitz.de>
References: <1349719669-11503-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1349807952.4683.12.camel@jlt4.sipsolutions.net>
	 <5074886E.1040400@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-09 at 13:26 -0700, Marco Porsch wrote:
> On 10/09/2012 11:39 AM, Johannes Berg wrote:
> >> Does it make any sense to test for NL80211_IFTYPE_AP and
> >> NL80211_IFTYPE_AP_VLAN everytime?
> >
> > Not sure how you mean that?
> >
> 
> See, I use the disjunction
> + if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
> +     sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
> at least 5 times. I thought in some situations it may be only necessary 
> to check for one of them, because of the function context.

I don't think so, but honestly, I haven't looked very closely :)

johannes

