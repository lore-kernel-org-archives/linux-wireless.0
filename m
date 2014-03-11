Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaCKNVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 09:21:42 -0400
Message-ID: <1394544099.30155.7.camel@jlt4.sipsolutions.net> (sfid-20140311_142149_500118_74600C0E)
Subject: Re: [PATCH 1/4] mac80211: refactor recalculate channel context
 functions (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Mar 2014 15:21:39 +0200
In-Reply-To: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com> (sfid-20140307_032035_187032_AF6A7CB1)
References: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
	 (sfid-20140307_032035_187032_AF6A7CB1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 10:17 +0800, Zhao, Gang wrote:
> Function ieee80211_change_chanctx() updates struct
> ieee80211_chanctx_conf's def and min_def members, in a somewhat mixed
> way. Since there are other members can be updated, this function's
> name is a bit inaccurate.
> 
> Rename ieee80211_change_chanctx() to ieee80211_recalc_chanctx_def()
> and only update def member in this function. Add a wrapper function
> _ieee80211_recalc_chanctx_chantype() to do ieee80211_change_chanctx()'s
> work.

I think this is reasonable, but as discussed in the other thread I'll
drop this until the CSA code settles down.

johannes

