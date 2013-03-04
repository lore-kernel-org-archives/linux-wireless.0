Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab3CDPgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:36:40 -0500
Message-ID: <1362411396.21028.27.camel@jlt4.sipsolutions.net> (sfid-20130304_163643_451197_B40AE9C6)
Subject: Re: [PATCH] mac80211: fix HT capability overrides for AP station
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com
Date: Mon, 04 Mar 2013 16:36:36 +0100
In-Reply-To: <1362135559-10295-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_115928_216136_186085DF)
References: <1362135559-10295-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130301_115928_216136_186085DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 11:59 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> HT capabilites are asymmetric -- e.g. beamforming is both a
> TX and RX capability. If, for example, we support RX but not
> TX, the RX capability of the AP station is masked out (if it
> supports it). This works correctly if it's really the driver
> capability.

Applied.

johannes

