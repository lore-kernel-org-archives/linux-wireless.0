Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3J1OM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:12:58 -0400
Message-ID: <1382969573.17956.17.camel@jlt4.sipsolutions.net> (sfid-20131028_151300_760271_352B15C1)
Subject: Re: [PATCH] nl80211: fix channel switch parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Mon, 28 Oct 2013 15:12:53 +0100
In-Reply-To: <1382969267-25506-1-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150759_995954_87DD2560)
References: <1382969267-25506-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131028_150759_995954_87DD2560)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 15:07 +0100, Johannes Berg wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> The nl80211 attribute NL80211_ATTR_CSA_C_OFF_BEACON should be nested
> inside NL80211_ATTR_CSA_IES, but commit ee4bc9e75811d2c0cb5f2a2fc5b5
> ("nl80211: enable IBSS support for channel switch announcements")
> added a check in the outer message attributes.
> 
> Fix channel switch calls by removing the erroneus condition.

Applied (Simon had already looked at it before)

johannes

