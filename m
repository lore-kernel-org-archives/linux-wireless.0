Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42854 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaAPOnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 09:43:31 -0500
Message-ID: <1389883404.4345.8.camel@jlt4.sipsolutions.net> (sfid-20140116_154335_603094_9FE62849)
Subject: Re: [PATCH] cfg80211: fix wiphy freq hint nl80211 policy
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Jan 2014 15:43:24 +0100
In-Reply-To: <1389882885-6950-1-git-send-email-michal.kazior@tieto.com> (sfid-20140116_153914_194112_A83B1F42)
References: <1389882885-6950-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140116_153914_194112_A83B1F42)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-16 at 15:34 +0100, Michal Kazior wrote:
> The attribute name was mistyped. Actual nl80211
> policy for NL80211_ATTR_WIPHY_FREQ_HINT was
> missing.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> 
> I've spoted this while rebasing some of my
> patches. This should apply on top of
> mac80211-next/master.

Huh. I was pretty sure I'd already fixed that when applying the patch,
how did I mention to write that into the commit log but not actually do
it?!

Since I'll rebase anyway next week I've rebased now to fix this ...

Sorry!

johannes

