Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2FZNbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 09:31:53 -0400
Message-ID: <1340717512.14634.38.camel@jlt3.sipsolutions.net> (sfid-20120626_153155_920482_94D03897)
Subject: Re: [RFC v3] respect channels in iface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 15:31:52 +0200
In-Reply-To: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 14:30 +0200, Michal Kazior wrote:
> Hi,
> 
> Here's a respin of my patches.
> 
> Changes:
> 
>  - add libertas set_channel tracking
>  - add channel switch notify support (ap channel tracking)
>  - introduce CFG80211_MAX_NUM_DIFFERENT_CHANNELS
>    (changes channel accounting a bit)
>  - add channel accounting for assoc
> 
> Left unchanged:
> 
>  - set_monitor_enabled callback name
>  - initial monitor channel is set to first one found

Dziękujemy! (and thanks google too :-D)

I just saw a few tiny issues, can you repost as [PATCH] and then, unless
I see other objections, I'll pick this up.

johannes

