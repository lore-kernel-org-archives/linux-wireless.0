Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3BNUYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:24:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U65MG-0004GL-U4
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 21:24:41 +0100
Message-ID: <1360873478.8210.20.camel@jlt4.sipsolutions.net> (sfid-20130214_212444_498581_33185CFA)
Subject: Re: [PATCH] mac80211: prevent spurious HT/VHT downgrade message
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 21:24:38 +0100
In-Reply-To: <1360840826-23188-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_122034_394749_8A612C00)
References: <1360840826-23188-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130214_122034_394749_8A612C00)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 12:20 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Even when connecting to an AP that doesn't support VHT,
> and even when the local device doesn't support it either,
> the downgrade message gets printed. Suppress the message
> if HT and/or VHT is disabled.

Applied.

johannes

