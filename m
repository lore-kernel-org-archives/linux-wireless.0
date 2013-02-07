Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab3BGUDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 15:03:01 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U3XgS-00080e-A9
	for linux-wireless@vger.kernel.org; Thu, 07 Feb 2013 21:03:00 +0100
Message-ID: <1360267405.8038.15.camel@jlt4.sipsolutions.net> (sfid-20130207_210306_191961_BDBA424B)
Subject: Re: [PATCH] mac80211: fix HT/VHT disable flags
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 07 Feb 2013 21:03:25 +0100
In-Reply-To: <1360266149-23352-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_204227_108467_61008154)
References: <1360266149-23352-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130207_204227_108467_61008154)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 20:42 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The code to disable HT and VHT if VHT was advertised
> without VHT is wrong -- it accidentally uses the wrong
> flags. Fix that.

FWIW, even though this is broken in 3.8 now, it doesn't matter because
there's no driver in there that has VHT, so I'm not going to apply it to
mac80211.git.

johannes

