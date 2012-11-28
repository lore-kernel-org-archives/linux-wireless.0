Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab2K1MZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:25:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tdgi4-0006cS-Uc
	for linux-wireless@vger.kernel.org; Wed, 28 Nov 2012 13:25:49 +0100
Message-ID: <1354105575.9345.3.camel@jlt4.sipsolutions.net> (sfid-20121128_132553_367681_A492EB7A)
Subject: Re: [PATCH] nl80211: remove unnecessary checks
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 13:26:15 +0100
In-Reply-To: <1353931105-10805-1-git-send-email-johannes@sipsolutions.net> (sfid-20121126_125802_517449_444EA480)
References: <1353931105-10805-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121126_125802_517449_444EA480)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 12:58 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The CQM TX-error rate/interval can't be less than
> zero since they're unsigned values, remove checks.
> Also fix indentation of the function.

Applied.

johannes

