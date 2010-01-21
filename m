Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36778 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab0AUWPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 17:15:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 0/2] ath5k AP mode fixes
Date: Thu, 21 Jan 2010 23:15:21 +0100
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <1264049464-12292-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1264049464-12292-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001212315.21908.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 21 January 2010 05:51:02 Bob Copeland wrote:
> Here are a couple of fixes to ath5k AP mode that have been
> kicking around for a bit.
> 
> The sleep clock is disabled by legacy HAL for AP mode and at
> least one person had beaconing issues as a result of our not
> also doing so.
> 
> Although we decided 'fix setup for CAB queue' was not ideal,
> there's no alternative at the moment and the current setup is
> causing problems for people, so IMO we should just take this
> patch as-is for now.
> 
> Bob Copeland (2):
>   ath5k: dont use external sleep clock in AP mode
>   ath5k: fix setup for CAB queue


Thanks a lot for these, Bob. I'll test them on my AP.

Important: Please also add CC:stable to the patches to make
sure they reach the endusers for 2.6.32.x.
2.6.32.x currently is unusable in AP mode, so these patches
are pretty important fixes (if they actually fix the issues.
But I assume that for now ;) )

-- 
Greetings, Michael.
