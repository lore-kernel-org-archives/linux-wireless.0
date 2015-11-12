Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55093 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbbKLWcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 17:32:10 -0500
Message-ID: <1447367523.2131.6.camel@sipsolutions.net> (sfid-20151112_233214_227826_64CAE36D)
Subject: Re: [PATCH v2] cfg80211: add VHT support for Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@codeaurora.org>, Peter Oh <poh@qca.qualcomm.com>,
	ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Nov 2015 23:32:03 +0100
In-Reply-To: <56451294.9060205@codeaurora.org>
References: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com>
	 <1447358605.2131.3.camel@sipsolutions.net>
	 <564505A6.9030001@codeaurora.org>
	 <1447364413.2131.5.camel@sipsolutions.net>
	 <56451294.9060205@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-12 at 14:28 -0800, Peter Oh wrote:
> 
> Exactly the same communication mechanism and purpose are used with 
> NL80211_EXT_FEATURE_VHT_IBSS which is already a part of NL80211
> feature 
> flag.
> The new feature flag, NL80211_EXT_FEATURE_VHT_MESH, follows the same 
> purpose and usage.

No, it doesn't. Check how the _IBSS one is used in the code to actually
*do* something.

johannes
