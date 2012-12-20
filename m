Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51472 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTLNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:13:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tle3s-0007EG-4Z
	for linux-wireless@vger.kernel.org; Thu, 20 Dec 2012 12:13:12 +0100
Message-ID: <1356002014.10029.1.camel@jlt4.sipsolutions.net> (sfid-20121220_121316_184441_4D55CD2B)
Subject: Re: [PATCH] mac80211: remove a bit of dead mesh code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 Dec 2012 12:13:34 +0100
In-Reply-To: <1355563147-10288-1-git-send-email-johannes@sipsolutions.net> (sfid-20121215_101857_701129_D81DC541)
References: <1355563147-10288-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121215_101857_701129_D81DC541)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-12-15 at 10:19 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In a file that's only built when CONFIG_MAC80211_MESH
> is defined, having an #ifdef on the same is entirely
> pointless, so remove it.

Applied.

johannes

