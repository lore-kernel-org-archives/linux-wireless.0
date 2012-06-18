Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2FRL5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 07:57:24 -0400
Message-ID: <1340020643.4615.5.camel@jlt3.sipsolutions.net> (sfid-20120618_135727_808256_C5F1EDA2)
Subject: Re: [PATCH v2] mac80211: set only VO as a U-APSD enabled AC
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
Date: Mon, 18 Jun 2012 13:57:23 +0200
In-Reply-To: <1340005430-7655-1-git-send-email-arik@wizery.com> (sfid-20120618_094354_854025_BF2962A4)
References: <1340005430-7655-1-git-send-email-arik@wizery.com>
	 (sfid-20120618_094354_854025_BF2962A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-18 at 10:43 +0300, Arik Nemtsov wrote:
> Some APs experience problems when working with U-APSD. Decrease the
> probability of that happening by using legacy mode for all ACs but VO.
> 
> The AP that caused us troubles was a Cisco 4410N. It ignores our
> setting, and always treats non-VO ACs as legacy.

Applied.

johannes

