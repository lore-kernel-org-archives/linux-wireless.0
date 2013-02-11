Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:51:31 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rv0-0000lu-48
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:51:30 +0100
Message-ID: <1360583487.8738.25.camel@jlt4.sipsolutions.net> (sfid-20130211_125352_222727_FA9F6462)
Subject: Re: [PATCH] mac80211: simplify idle handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:51:27 +0100
In-Reply-To: <1360192626-13998-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_001654_967351_CB04CCD5)
References: <1360192626-13998-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130207_001654_967351_CB04CCD5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 00:17 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Now that we have channel contexts, idle is (pretty
> much) equivalent to not having a channel context.
> Change the code to use this relation so that there
> no longer is a need for a lot of idle recalculate
> calls everywhere.

Applied.

johannes

