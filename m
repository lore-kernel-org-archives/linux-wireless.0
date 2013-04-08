Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934555Ab3DHJE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 05:04:56 -0400
Message-ID: <1365411891.25475.0.camel@jlt4.sipsolutions.net> (sfid-20130408_110503_073715_9D5445FA)
Subject: Re: [PATCH] mac80211: disable uAPSD if all ACs are under ACM
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Mon, 08 Apr 2013 11:04:51 +0200
In-Reply-To: <1365167071-2450-1-git-send-email-johannes@sipsolutions.net> (sfid-20130405_150446_432380_9604795F)
References: <1365167071-2450-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130405_150446_432380_9604795F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-05 at 15:04 +0200, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> It's unlikely that an AP requires WMM mandatory admission control
> for all access categories, and if it does then we still transmit
> on the background AC without requesting admission. However, avoid
> using uAPSD in this case since the implementation could run into
> issues and might use other ACs etc.

Applied.

johannes

