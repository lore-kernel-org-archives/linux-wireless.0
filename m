Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2J2JJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:09:12 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TSlLL-00035g-Ng
	for linux-wireless@vger.kernel.org; Mon, 29 Oct 2012 10:09:11 +0100
Message-ID: <1351501787.10925.7.camel@jlt4.sipsolutions.net> (sfid-20121029_100920_684778_E8719A9B)
Subject: Re: [PATCH 0/3] mac80211: audit for access to skb data
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 29 Oct 2012 10:09:47 +0100
In-Reply-To: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_004611_616574_5C6C9420)
References: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121026_004611_616574_5C6C9420)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 00:46 +0200, Johannes Berg wrote:
> While looking at Javier's patch and some other things I found
> a number of places that don't make sure the skb data is there
> when it's accessed, fix them.

Applied all three to mac80211.git.

johannes

