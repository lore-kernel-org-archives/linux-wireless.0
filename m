Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3CDPdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:33:21 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UCXOC-0004Wh-02
	for linux-wireless@vger.kernel.org; Mon, 04 Mar 2013 16:33:20 +0100
Message-ID: <1362411197.21028.23.camel@jlt4.sipsolutions.net> (sfid-20130304_163324_430478_FEF1E0CB)
Subject: Re: [PATCH] mac80211: remove IEEE80211_KEY_FLAG_WMM_STA
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 16:33:17 +0100
In-Reply-To: <1362089915-12075-1-git-send-email-johannes@sipsolutions.net> (sfid-20130228_231848_325408_1F97A262)
References: <1362089915-12075-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130228_231848_325408_1F97A262)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 23:18 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no driver using this flag, so it seems
> that all drivers support HW crypto with WMM or
> don't support it at all. Remove the flag and
> code setting it.

Applied.

johannes

