Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab3CDPfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:35:22 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UCXQ9-0004be-9b
	for linux-wireless@vger.kernel.org; Mon, 04 Mar 2013 16:35:21 +0100
Message-ID: <1362411318.21028.25.camel@jlt4.sipsolutions.net> (sfid-20130304_163524_975605_1EB4BB90)
Subject: Re: [PATCH 1/2] mac80211: flush keys when stopping AP
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 16:35:18 +0100
In-Reply-To: <1362089971-12182-1-git-send-email-johannes@sipsolutions.net> (sfid-20130228_231938_867224_2603DCF9)
References: <1362089971-12182-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130228_231938_867224_2603DCF9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 23:19 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since hostapd will remove keys this isn't usually
> an issue, but we shouldn't leak keys to the next
> BSS started on the same interface. For VLANs this
> also fixes a bug, keys that aren't removed would
> otherwise be leaked.

Applied both.

johannes

