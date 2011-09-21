Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1IUMHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 08:07:00 -0400
Subject: Re: [RFC 4/5] mac80211: add a HW flag for TDLS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1316082334-7664-5-git-send-email-arik@wizery.com> (sfid-20110915_123358_258921_F572C594)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-5-git-send-email-arik@wizery.com>
	 (sfid-20110915_123358_258921_F572C594)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 14:06:55 +0200
Message-ID: <1316606815.3940.31.camel@jlt3.sipsolutions.net> (sfid-20110921_140702_897880_28D9B9AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
> Allow TDLS operations and peers only in supporting hardware.

In terms of patch ordering I think this should be part of patch 1 (and
maybe patch 3 can be too), otherwise patch 2 adds some incomplete
mac80211 stuff and even enables it ...

johannes


