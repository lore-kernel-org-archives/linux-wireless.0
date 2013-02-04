Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3BDPiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:38:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2O84-0002z2-ME
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:38:44 +0100
Message-ID: <1359992350.10311.17.camel@jlt4.sipsolutions.net> (sfid-20130204_163849_300094_BFCE96A8)
Subject: Re: [PATCH 1/2] cfg80211: refactor hidden SSID finding
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:39:10 +0100
In-Reply-To: <1359503120-25685-1-git-send-email-johannes@sipsolutions.net> (sfid-20130130_004508_523732_488C5419)
References: <1359503120-25685-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130130_004508_523732_488C5419)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 00:45 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of duplicating the rbtree functions, pass
> an argument to the compare function. This removes
> the code duplication for the two searches.

Applied (the version with the !ie1 && !ie2 fix)

johannes

