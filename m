Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967300Ab3DRMRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 08:17:51 -0400
Message-ID: <1366287462.8336.0.camel@jlt4.sipsolutions.net> (sfid-20130418_141755_197993_16A52C1F)
Subject: Re: [PATCH 1/2] mac80211: minstrel_ht: pick only supported rates
 for sta and group max*rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Date: Thu, 18 Apr 2013 14:17:42 +0200
In-Reply-To: <1366285887-23416-1-git-send-email-karl.beldan@gmail.com> (sfid-20130418_135545_662796_FFEAEFAA)
References: <1366285887-23416-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130418_135545_662796_FFEAEFAA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-18 at 13:51 +0200, Karl Beldan wrote:

> +			// initialize {mg,mi}->max_rates indexes

Please don't use C99 comments (both here and the other patch)

johannes

