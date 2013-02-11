Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab3BKK7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 05:59:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4r6v-0008Gd-HH
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 11:59:45 +0100
Message-ID: <1360580383.8738.9.camel@jlt4.sipsolutions.net> (sfid-20130211_120129_806226_42BAA036)
Subject: Re: [PATCH] mac80211: fix channel selection bug
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 11:59:43 +0100
In-Reply-To: <1360577653-20260-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_111423_564069_232BE3F9)
References: <1360577653-20260-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130211_111423_564069_232BE3F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 11:14 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When trying to connect to an AP that advertises HT but not
> VHT, the mac80211 code erroneously uses the configuration
> from the AP as is instead of checking it against regulatory
> and local capabilities. This can lead to using an invalid
> or even inexistent channel (like 11/HT40+).
> 
> Additionally, the return flags from downgrading must be
> ORed together, to collect them from all of the downgrades.
> Also clarify the message.

Applied.

johannes

