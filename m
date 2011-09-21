Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1IUMGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 08:06:17 -0400
Subject: Re: [RFC 3/5] nl80211/mac80211: allow adding TDLS peers as stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1316082334-7664-4-git-send-email-arik@wizery.com> (sfid-20110915_122552_918148_08AA1F92)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-4-git-send-email-arik@wizery.com>
	 (sfid-20110915_122552_918148_08AA1F92)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 14:06:12 +0200
Message-ID: <1316606772.3940.30.camel@jlt3.sipsolutions.net> (sfid-20110921_140619_959765_E24C2550)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
> When a TDLS peer STA is added it is marked with a new flag in both
> nl80211 and in mac80211.

I think it'd make some sense to allow only TDLS stations on a managed
mode interface?

johannes


