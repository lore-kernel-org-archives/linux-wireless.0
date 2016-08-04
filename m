Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56445 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbcHDGaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 02:30:19 -0400
Message-ID: <1470289823.2661.1.camel@sipsolutions.net> (sfid-20160804_083024_316337_1860BE61)
Subject: Re: [PATCH v2] nl80211: Receive correct value for
 NL80211_MESHCONF_HT_OPMODE command
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
Date: Thu, 04 Aug 2016 07:50:23 +0200
In-Reply-To: <d193404d-8a77-8a8e-10eb-f46bd4008384@gmail.com> (sfid-20160804_023726_609659_1BF1EFA8)
References: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
 <1470138089-6864-1-git-send-email-masashi.honma@gmail.com>
 <9967cc0f-777e-31f6-0c4a-a788e92b9049@gmail.com>
 <1470207156.2638.9.camel@sipsolutions.net>
	 <d193404d-8a77-8a8e-10eb-f46bd4008384@gmail.com>
	 (sfid-20160804_023726_609659_1BF1EFA8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> And I think checking only in wpa_supplicant is not good idea. Because
> other user application can access to the kernel API. If invalid flag
> combination causes kernel panic, it could be kernel vulnerability.
> 

I don't really see how that should confuse a driver into a panic, but
fair enough.

johannes
