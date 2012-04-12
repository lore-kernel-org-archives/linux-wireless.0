Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2DLDka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 23:40:30 -0400
Message-ID: <1334201996.3788.3.camel@jlt3.sipsolutions.net> (sfid-20120412_054034_375428_315DCB0B)
Subject: Re: [PATCH 00/10] Wireless patches for wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 12 Apr 2012 05:39:56 +0200
In-Reply-To: <1334166738-28243-1-git-send-email-greearb@candelatech.com> (sfid-20120411_195246_310207_9F34AD4B)
References: <1334166738-28243-1-git-send-email-greearb@candelatech.com>
	 (sfid-20120411_195246_310207_9F34AD4B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-11 at 10:52 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Support Ethtool stats for Wireless, including in-depth
> stats for ath9k, and add some additional ath9k stats
> to debugfs.  Support scanning on-channel.

Please don't mix two completely different things in a single series of
patches. I almost skipped this completely since I already saw the
ethtool stuff and don't care about ath9k stats, but clearly I need to
look at the scan thing ...

johannes

