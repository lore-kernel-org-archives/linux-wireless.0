Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52525 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759359Ab2INMIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:08:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TCUhD-0006FV-2E
	for linux-wireless@vger.kernel.org; Fri, 14 Sep 2012 14:08:31 +0200
Message-ID: <1347624549.4060.1.camel@jlt4.sipsolutions.net> (sfid-20120914_140837_534817_4890883F)
Subject: Re: [PATCH] mac80211: change locking around ieee80211_recalc_smps
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 14 Sep 2012 14:09:09 +0200
In-Reply-To: <1347367566-30660-1-git-send-email-johannes@sipsolutions.net> (sfid-20120911_144531_648560_39799CAE)
References: <1347367566-30660-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120911_144531_648560_39799CAE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-11 at 14:46 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Make the function acquire the necessary mutex itself
> to simplify the callers.

Applied.

johannes

