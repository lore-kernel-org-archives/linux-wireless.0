Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37318 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbbETNXS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:23:18 -0400
Message-ID: <1432128196.19214.15.camel@sipsolutions.net> (sfid-20150520_152323_982495_29A0F407)
Subject: Re: [PATCH 2/2] mac80211: guard against invalid ptr deref
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 May 2015 15:23:16 +0200
In-Reply-To: <1432039021-29666-2-git-send-email-michal.kazior@tieto.com> (sfid-20150519_143716_324286_1AEAADD3)
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	 <1432039021-29666-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150519_143716_324286_1AEAADD3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-19 at 14:37 +0200, Michal Kazior wrote:
> Without "cfg80211: ignore netif running state when
> changing iftype" it was possible for mac80211 to
> crash the system due to an unexpected (and
> incorrect) flow.
> 
> Even with cfg80211 being fixed it still makes
> sense to add a sanity check just in case.

Since the description of this makes no sense standalone, I'm not
applying this, and I'd like to ask you to change it even if we apply
both to make more sense on its own.

johannes

