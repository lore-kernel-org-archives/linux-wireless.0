Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53109 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKNbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 08:31:49 -0500
Message-ID: <1357911132.9767.2.camel@jlt4.sipsolutions.net> (sfid-20130111_143153_205497_2B984926)
Subject: Re: [PATCH] wireless: fix regulatory HT40 allowed check
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Jan 2013 14:32:12 +0100
In-Reply-To: <1357910578-6988-1-git-send-email-nbd@openwrt.org>
References: <1357910578-6988-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-11 at 14:22 +0100, Felix Fietkau wrote:
> commit 1a9193185f462a51815fe48491f8a6fb6b942551 "regulatory: code cleanup"
> changed is_ht40_allowed without considering that IEEE80211_CHAN_NO_HT40 is
> not just one flag, but two.
> This is causing HT40- to be blocked completely.

Applied, sorry about that.

johannes

