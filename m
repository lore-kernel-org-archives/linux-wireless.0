Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CRTMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:12:21 -0400
Message-ID: <1363633936.8260.6.camel@jlt4.sipsolutions.net> (sfid-20130318_201225_756168_EEAB92C7)
Subject: Re: [PATCH 1/3] mac80211/minstrel_ht: improve rate selection
 stability
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 18 Mar 2013 20:12:16 +0100
In-Reply-To: <1363449627-10884-1-git-send-email-nbd@openwrt.org>
References: <1363449627-10884-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-03-16 at 17:00 +0100, Felix Fietkau wrote:
> Under load, otherwise stable rates can easily fluctuate because of
> collisions. In my tests on a clean channel, the success probability of
> the max throughput rate often stays somewhere between 90% and 100% under
> load. This can cause some unnecessary switching to lower rates.
> This patch improves stability by treating success probability values
> between 90% and 100% the same.
> In my tests on a 3x3 HT20 link with lots of TCP traffic, it improves the
> average throughput by a few mbit/s.

Applied all, thanks.

johannes

