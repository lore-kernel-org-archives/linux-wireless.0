Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2HAIqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 04:46:17 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwUZM-0002tE-6A
	for linux-wireless@vger.kernel.org; Wed, 01 Aug 2012 10:46:16 +0200
Message-ID: <1343810773.4638.2.camel@jlt3.sipsolutions.net> (sfid-20120801_104622_056033_9B58279F)
Subject: Re: [PATCH] mac80211: use eth_broadcast_addr
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 01 Aug 2012 10:46:13 +0200
In-Reply-To: <1343744471-5910-1-git-send-email-johannes@sipsolutions.net> (sfid-20120731_162119_446571_FCF4993F)
References: <1343744471-5910-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120731_162119_446571_FCF4993F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-31 at 16:21 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of memset().

Applied.

johannes

