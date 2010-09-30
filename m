Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0I3Hmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 03:42:38 -0400
Subject: Re: [RFC 1/2] wireless:  Show sta_flags for status in
 /proc/net/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285804637-5400-1-git-send-email-greearb@candelatech.com>
References: <1285804637-5400-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 09:43:07 +0200
Message-ID: <1285832587.3639.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 16:57 -0700, greearb@candelatech.com wrote:

> User-space can then decode the flags to determine associated,
> scanning, and other states.

I really don't think we should be extending the useful life of wireless
extensions.


>   * @signal: signal strength of last received packet in dBm
> + * @status: ieee80211_sta_info_flags plus:  (1<<15) Scanning.


And are you seriously proposing to make internal mac80211 flags part of
the externally visible cfg80211 API??

johannes

