Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1KUJpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 04:45:08 -0500
Subject: Re: [PATCH] cfg80211: fix regulatory NULL dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1321868640.3999.17.camel@jlt3.sipsolutions.net> (sfid-20111121_104413_868989_62927AFC)
References: <1321868640.3999.17.camel@jlt3.sipsolutions.net>
	 (sfid-20111121_104413_868989_62927AFC)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 10:45:00 +0100
Message-ID: <1321868700.3999.18.camel@jlt3.sipsolutions.net> (sfid-20111121_104511_474797_BC88F2F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 10:44 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> By the time userspace returns with a response to
> the regulatory domain request, the wiphy causing
> the request might have gone away. If this is so,
> reject the update but mark the request as having
> been processed anyway.
> 
> Cc: Luis R. Rodriguez <lrodriguez@qca.qualcomm.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Oops, Cc: stable@vger.kernel.org

johannes

