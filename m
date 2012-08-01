Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab2HAIpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 04:45:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwUZ0-0002sU-Hm
	for linux-wireless@vger.kernel.org; Wed, 01 Aug 2012 10:45:54 +0200
Message-ID: <1343810752.4638.1.camel@jlt3.sipsolutions.net> (sfid-20120801_104600_461273_0A0300F2)
Subject: Re: [PATCH] mac80211: enable WDS carrier only after adding station
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 01 Aug 2012 10:45:52 +0200
In-Reply-To: <1343671171-9768-1-git-send-email-johannes@sipsolutions.net> (sfid-20120730_195936_996417_3053D468)
References: <1343671171-9768-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120730_195936_996417_3053D468)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-30 at 19:59 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Enable the carrier on WDS type interfaces only
> after having added the station entry for the
> WDS peer so outgoing frames will find it.

Applied.

johannes

