Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab1KXQos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 11:44:48 -0500
Subject: Re: [RFC 2/5] cfg80211: add support to immediately apply reg
 settings
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1322062858-15276-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_164114_908482_5AFBED2B)
References: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
	 <1322062858-15276-3-git-send-email-mcgrof@qca.qualcomm.com>
	 (sfid-20111123_164114_908482_5AFBED2B)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 17:44:43 +0100
Message-ID: <1322153083.5366.26.camel@jlt3.sipsolutions.net> (sfid-20111124_174452_144479_3C35FA83)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-23 at 10:40 -0500, Luis R. Rodriguez wrote:
> It is useful to apply reguatory settings immediately. We already
> handle applying regulatory hints immediatey for most hints but
> for user hints and country IE hints we want to kick hardware
> immediately to make these changes take effect. This adds supports
> to let us kick hardware to make the changes take effect as soon
> as possible.

Can't say I like this -- wouldn't we rather call the regulatory update
callback or so?

johannes

