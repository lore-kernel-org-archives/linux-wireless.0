Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33283 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754843Ab2FGH5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 03:57:17 -0400
Message-ID: <1339055836.6009.20.camel@joe2Laptop> (sfid-20120607_095720_859457_C19E1B2B)
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
From: Joe Perches <joe@perches.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Jun 2012 00:57:16 -0700
In-Reply-To: <4FD05A27.80102@qca.qualcomm.com>
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1339050308.6009.9.camel@joe2Laptop> <4FD0540C.5060808@qca.qualcomm.com>
	 <1339053852.6009.13.camel@joe2Laptop> <4FD05A27.80102@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 13:07 +0530, Mohammed Shafi Shajakhan wrote:
> what about the other wiphy_debug messages, we would 
> still retain them know

Yes, and...

No, you know those should now still be wiphy_debug
unless the message is HT related and need a new change.

All sorts of kneed/need, knitting/nitting bits are in
my head right now, but I'll spare all of you any more.

English is still a spelt-silly language.

cheers, Joe

