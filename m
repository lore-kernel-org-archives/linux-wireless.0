Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2K3MmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:42:22 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TePvB-0002be-9w
	for linux-wireless@vger.kernel.org; Fri, 30 Nov 2012 13:42:21 +0100
Message-ID: <1354279365.10035.28.camel@jlt4.sipsolutions.net> (sfid-20121130_134226_131577_465333E6)
Subject: Re: [PATCH] cfg80211: don't BUG_ON BSS struct issues
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 13:42:45 +0100
In-Reply-To: <1354137360-22334-1-git-send-email-johannes@sipsolutions.net> (sfid-20121128_221539_615597_A4C1D366)
References: <1354137360-22334-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121128_221539_615597_A4C1D366)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 22:16 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no need to stop the machine, just leak
> the BSS entry if there's an issue with its hold
> counter when freeing.

Applied.

johannes

