Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3BMXqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 18:46:04 -0500
Message-ID: <1360799156.8868.31.camel@jlt4.sipsolutions.net> (sfid-20130214_004608_479118_D4567E86)
Subject: Re: [PATCH 2/3] cfg80211: check (VHT) bandwidth against regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, green@qca.qualcomm.com
Date: Thu, 14 Feb 2013 00:45:56 +0100
In-Reply-To: <1360797364-9430-3-git-send-email-johannes@sipsolutions.net> (sfid-20130214_001638_848465_611403FD)
References: <1360797364-9430-1-git-send-email-johannes@sipsolutions.net>
	 <1360797364-9430-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130214_001638_848465_611403FD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 00:16 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Now that we can access the regulatory database without
> holding locks, check the desired bandwidth against it
> when a channel definition is checked. This addresses
> the missing VHT bandwidth check, HT is already handled
> by setting flags when the regdomain changes.

Actually, this patch isn't necessary, the next one handles the no-80 and
no-160 flags just fine ... I'll drop this.

johannes

