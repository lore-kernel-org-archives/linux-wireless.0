Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:49:08 -0500
Message-ID: <1360583343.8738.19.camel@jlt4.sipsolutions.net> (sfid-20130211_124911_614495_A4EADAB8)
Subject: Re: [PATCH] mac80211: add vif debugfs driver callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Mon, 11 Feb 2013 12:49:03 +0100
In-Reply-To: <1360064962-19946-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_124902_865037_2359A3C9)
References: <1360064962-19946-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130205_124902_865037_2359A3C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 12:49 +0100, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> Add debugfs driver callbacks so drivers can add
> debugfs entries for interfaces. Note that they
> _must_ remove the entries again as add/remove in
> the driver doesn't correspond to add/remove in
> debugfs; the former is up/down while the latter
> is netdev create/destroy.

Applied.

johannes

