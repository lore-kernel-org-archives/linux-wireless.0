Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KGRAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 12:00:08 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TW8z1-00073b-DA
	for linux-wireless@vger.kernel.org; Wed, 07 Nov 2012 18:00:07 +0100
Message-ID: <1352307643.9854.9.camel@jlt4.sipsolutions.net> (sfid-20121107_180021_072482_88195E6F)
Subject: Re: [PATCH] mac80211: use mac_pton
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 07 Nov 2012 18:00:43 +0100
In-Reply-To: <1352143727-29422-1-git-send-email-johannes@sipsolutions.net> (sfid-20121105_202827_044531_BA5B3ACF)
References: <1352143727-29422-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121105_202827_044531_BA5B3ACF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-05 at 20:28 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of implementing practically the same
> function (hwaddr_aton) use mac_pton.

Applied.

johannes

