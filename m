Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2LEI6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 03:58:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TgAny-00020o-U0
	for linux-wireless@vger.kernel.org; Wed, 05 Dec 2012 09:58:11 +0100
Message-ID: <1354697917.9972.3.camel@jlt4.sipsolutions.net> (sfid-20121205_095817_130351_73E522A0)
Subject: Re: [PATCH] cfg80211: honour no-OFDM flag for channel wider than 20
 MHz
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 05 Dec 2012 09:58:37 +0100
In-Reply-To: <1354650666-28067-1-git-send-email-johannes@sipsolutions.net> (sfid-20121204_205047_309032_0C83467F)
References: <1354650666-28067-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121204_205047_309032_0C83467F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-04 at 20:51 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For channels wider than 20 MHz OFDM will be used, so when
> checking whether or not a channel is usable, check for the
> no-OFDM flag if the channel is wider than 20 MHz.

Applied (but I changed the subject to "cfg80211: check no-OFDM flag for
channels wider than 20 MHz")

johannes

