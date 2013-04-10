Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936567Ab3DJMlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:41:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UPuL2-0001Sm-6p
	for linux-wireless@vger.kernel.org; Wed, 10 Apr 2013 14:41:20 +0200
Message-ID: <1365597674.8388.12.camel@jlt4.sipsolutions.net> (sfid-20130410_144123_697742_B946A01B)
Subject: Re: [PATCH] mac80211: always advertise STBC/MCSes even if no AP
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 10 Apr 2013 14:41:14 +0200
In-Reply-To: <1365405581-9842-1-git-send-email-johannes@sipsolutions.net> (sfid-20130408_091951_601288_16277AAE)
References: <1365405581-9842-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130408_091951_601288_16277AAE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 09:19 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Advertise STBC capabilities and MCS rates even if the AP
> doesn't support them. This has always been the right thing
> to do, but used to be problematic with some APs. Now WFA
> testing requires this so re-enable it, problematic APs
> would then presumably not pass the test and be fixed.

Applied.

johannes

