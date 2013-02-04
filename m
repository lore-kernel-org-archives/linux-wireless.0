Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3BDPoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:44:30 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2ODc-000373-W2
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:44:29 +0100
Message-ID: <1359992689.10311.26.camel@jlt4.sipsolutions.net> (sfid-20130204_164433_539550_FA45EAAB)
Subject: Re: [PATCH] cfg80211: use lockdep to assert lock is held
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:44:49 +0100
In-Reply-To: <1359677685-23827-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_011424_988506_7DCE7B9A)
References: <1359677685-23827-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130201_011424_988506_7DCE7B9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-01 at 01:14 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of annotating with a comment, add a lockdep
> annotation which also serves as documentation.

Applied.

johannes

