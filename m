Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3APOJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 09:09:20 -0500
Message-ID: <1358345384.22862.9.camel@jlt4.sipsolutions.net> (sfid-20130116_150923_731067_6FDF135C)
Subject: Re: [PATCH] mac80211: fix monitor mode injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 15:09:44 +0100
In-Reply-To: <1358115026-6090-1-git-send-email-nbd@openwrt.org>
References: <1358115026-6090-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-01-13 at 23:10 +0100, Felix Fietkau wrote:
> Channel contexts are not always used with monitor interfaces. If no channel
> context is set, use the oper channel, otherwise tx fails.

Applied, but I also added a check for local->use_chanctx.

johannes

