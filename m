Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2FLOJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:09:48 -0400
Message-ID: <1339510185.4531.12.camel@jlt3.sipsolutions.net> (sfid-20120612_161006_162567_11B3F97A)
Subject: Re: [PATCH] mac80211: handle auth failure returned with unmatching
 auth algo
From: Johannes Berg <johannes@sipsolutions.net>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 12 Jun 2012 16:09:45 +0200
In-Reply-To: <1339497630-31589-1-git-send-email-eyal@wizery.com> (sfid-20120612_124040_149514_85613F43)
References: <1339497630-31589-1-git-send-email-eyal@wizery.com>
	 (sfid-20120612_124040_149514_85613F43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 13:40 +0300, Eyal Shapira wrote:
> Some Netgear APs like WNAP210 have a quirk behavior when
> configured for WEP Shared. They send an auth response with algo
> SHARED and status code NOT_SUPPORTED_AUTH_ALG (13) when being
> sent a request made with auth algo OPEN. Enable such response to
> propagate to userspace instead of discarding it so wpa_s can
> reattempt to auth with SHARED.

Does cfg80211 need to handle this? How does wpa_s even handle it?

johannes

