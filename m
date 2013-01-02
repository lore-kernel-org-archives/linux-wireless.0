Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3ABKvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 05:51:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TqLvD-0004Fd-V2
	for linux-wireless@vger.kernel.org; Wed, 02 Jan 2013 11:51:44 +0100
Message-ID: <1357123930.9839.4.camel@jlt4.sipsolutions.net> (sfid-20130102_115147_048476_9FE7200B)
Subject: Re: [PATCH] wireless: use __aligned
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 11:52:10 +0100
In-Reply-To: <1356694012-25695-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_122635_360904_AEB4C87D)
References: <1356694012-25695-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121228_122635_360904_AEB4C87D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-28 at 12:26 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Use __aligned(...) instead of __attribute__((aligned(...)))
> in mac80211 and cfg80211.

Applied.

johannes

