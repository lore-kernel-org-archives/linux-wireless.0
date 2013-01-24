Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3AXPHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 10:07:23 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TyOOf-0008Vz-V3
	for linux-wireless@vger.kernel.org; Thu, 24 Jan 2013 16:07:22 +0100
Message-ID: <1359040067.21908.5.camel@jlt4.sipsolutions.net> (sfid-20130124_160726_839793_31F3B92A)
Subject: Re: [PATCH] mac80211: remove redundant check
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 24 Jan 2013 16:07:47 +0100
In-Reply-To: <1358541563-14448-1-git-send-email-johannes@sipsolutions.net> (sfid-20130118_213906_219300_3BEE8B84)
References: <1358541563-14448-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130118_213906_219300_3BEE8B84)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-18 at 21:39 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no need to have two checks for "associated"
> in ieee80211_sta_restart(), make the first one locked
> to not race (unlikely at this point during resume)
> and remove the second check.

Applied.

johannes

