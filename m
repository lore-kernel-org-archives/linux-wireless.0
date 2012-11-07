Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2KGRAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 12:00:55 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TW8zl-00074P-Ut
	for linux-wireless@vger.kernel.org; Wed, 07 Nov 2012 18:00:54 +0100
Message-ID: <1352307691.9854.11.camel@jlt4.sipsolutions.net> (sfid-20121107_180057_204276_DC07B064)
Subject: Re: [PATCH] mac80211: use kstrtoull return value
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 07 Nov 2012 18:01:31 +0100
In-Reply-To: <1352143887-30654-1-git-send-email-johannes@sipsolutions.net> (sfid-20121105_203102_312615_D3ED23D4)
References: <1352143887-30654-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121105_203102_312615_D3ED23D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-05 at 20:31 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If kstrtoull() returns an error code (a value
> smaller than zero), use it since it can be an
> error other than -EINVAL.

Applied.

johannes

