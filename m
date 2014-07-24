Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32948 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbaGXKua (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:50:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <johannes@sipsolutions.net>)
	id 1XAGbT-0007Cg-4s
	for linux-wireless@vger.kernel.org; Thu, 24 Jul 2014 12:50:27 +0200
Message-ID: <1406199024.14675.9.camel@jlt4.sipsolutions.net> (sfid-20140724_125033_132003_608DBB5B)
Subject: Re: [PATCH] mac80211: don't duplicate station QoS capability data
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 24 Jul 2014 12:50:24 +0200
In-Reply-To: <1406198192-29442-1-git-send-email-johannes@sipsolutions.net> (sfid-20140724_123645_348075_85F44270)
References: <1406198192-29442-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20140724_123645_348075_85F44270)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 12:36 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> We currently track the QoS capability twice: for all peer stations
> in the WLAN_STA_WME flag, and for any clients associated to an AP
> interface separately for drivers in the sta->sta.wme field.
> 
> Remove the WLAN_STA_WME flag and track the capability only in the
> driver-visible field, getting rid of the limitation that the field
> is only valid in AP mode.

Err, fixing mesh compilation ...

johannes

