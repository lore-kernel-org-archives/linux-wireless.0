Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:51:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rvL-0000ly-30
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:51:51 +0100
Message-ID: <1360583508.8738.26.camel@jlt4.sipsolutions.net> (sfid-20130211_125453_025053_F81B0953)
Subject: Re: [PATCH] mac80211: remove unused code to mark AP station
 authenticated
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:51:48 +0100
In-Reply-To: <1360254021-23864-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_172008_833059_4995DCD4)
References: <1360254021-23864-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130207_172008_833059_4995DCD4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 17:20 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When we get to association, the AP station already exists and
> is marked authenticated, so moving it into IEEE80211_STA_AUTH
> again is a NOP, remove it.

Applied.

johannes

