Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab1LFM06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 07:26:58 -0500
Subject: Re: [PATCHv2 0/3] add HT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1322668595-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1322668595-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 13:26:53 +0100
Message-ID: <1323174413.4696.19.camel@jlt3.sipsolutions.net> (sfid-20111206_132708_077423_F47E7B2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-30 at 16:56 +0100, Simon Wunderlich wrote:
> This patch set adds support for HT datarates in IBSS. It is based on Alexander
> Simons previous work. The changes can be found in the individual patch messages.

Looks good to me, I only wonder if all drivers are willing to support
NL80211_FEATURE_HT_IBSS. If there's any driver not willing to have it,
we'd have to move setting it into drivers.

Anyway, we can do that later.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

