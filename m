Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3EPVBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:01:24 -0400
Message-ID: <1368738079.8253.10.camel@jlt4.sipsolutions.net> (sfid-20130516_230127_684714_FC6A803B)
Subject: Re: [PATCH] mac80211: enable power save only if DTIM period is
 available
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Thu, 16 May 2013 23:01:19 +0200
In-Reply-To: <1368195048-27326-1-git-send-email-johannes@sipsolutions.net> (sfid-20130510_161057_623544_1F856B7B)
References: <1368195048-27326-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130510_161057_623544_1F856B7B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-10 at 16:10 +0200, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> Generally, the DTIM period is available after a beacon has
> been received, and if no beacon has been received enabling
> powersave is problematic anyway for synchronisation. Since
> some drivers may require the DTIM period for powersave,
> don't enable powersave until it becomes available in case
> the scan/association managed to not receive a beacon.

Applied.

johannes

