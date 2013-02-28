Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55723 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130Ab3B1WMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:12:51 -0500
Message-ID: <1362089562.8330.5.camel@jlt4.sipsolutions.net> (sfid-20130228_231257_972886_264A7568)
Subject: Re: [PATCH 3.9] mac80211: really fix monitor mode channel reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sujith@msujith.org
Date: Thu, 28 Feb 2013 23:12:42 +0100
In-Reply-To: <1362042084-26920-1-git-send-email-johannes@sipsolutions.net> (sfid-20130228_100138_531258_899933FC)
References: <1362042084-26920-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130228_100138_531258_899933FC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 10:01 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> After Felix's patch it was still broken in case you
> used more than just a single monitor interface. Fix
> it better now.

Applied.

johannes

