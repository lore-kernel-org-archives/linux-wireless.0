Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3BDPlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:41:03 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2OAH-00033Z-HM
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:41:02 +0100
Message-ID: <1359992486.10311.21.camel@jlt4.sipsolutions.net> (sfid-20130204_164107_605978_7E33FBF7)
Subject: Re: [PATCH] mac80211: remove unused SSID from BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:41:26 +0100
In-Reply-To: <1359533112-13100-1-git-send-email-johannes@sipsolutions.net> (sfid-20130130_090452_657274_525C3C61)
References: <1359533112-13100-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130130_090452_657274_525C3C61)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 09:05 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The ssid/ssid_len fields in the private BSS
> struct are unused, contrary to the comment
> we do look up the SSID in the few cases we
> need it.

Applied.

johannes

