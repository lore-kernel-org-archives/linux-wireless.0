Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaAIJSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 04:18:50 -0500
Message-ID: <1389259126.4348.1.camel@jlt4.sipsolutions.net> (sfid-20140109_101855_216724_6D754BC0)
Subject: Re: [PATCH 1/2 v2] cfg80211: Add a function to get the number of
 supported channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 09 Jan 2014 10:18:46 +0100
In-Reply-To: <1389259051-18072-1-git-send-email-ilan.peer@intel.com> (sfid-20140109_101612_081487_E0BEE015)
References: <1388503946-25862-2-git-send-email-ilan.peer@intel.com>
	 <1389259051-18072-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20140109_101612_081487_E0BEE015)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-09 at 11:17 +0200, Ilan Peer wrote:

> +unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy)
> +{
> +	enum ieee80211_band band;
> +	unsigned int n_channels;

Seems nicer to do the = 0 here rather than in the loop?

> +	for (band = 0, n_channels = 0; band < IEEE80211_NUM_BANDS; band++)

johannes

