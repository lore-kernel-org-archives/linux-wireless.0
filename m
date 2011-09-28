Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1I1MRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:17:52 -0400
Subject: Re: [PATCH 00/15] mac80211 uAPSD support
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110928120849.882884360@sipsolutions.net> (sfid-20110928_141249_243564_22D2F86A)
References: <20110928120849.882884360@sipsolutions.net>
	 (sfid-20110928_141249_243564_22D2F86A)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 14:17:48 +0200
Message-ID: <1317212268.3986.11.camel@jlt3.sipsolutions.net> (sfid-20110928_141755_568249_00B506A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-28 at 14:08 +0200, Johannes Berg wrote:
> I've tested this more, and am happy with it. There'll probably
> be some bugs, but hopefully nothing bad.
> 
> The series now also comes with documentation.
> 
> Drivers still need to enable uAPSD on a per-driver basis since
> it isn't guaranteed that they support it.

I should also mention that you need Eliad's uAPSD patches for hostapd,
and need to enable it in the config there as well
(uapsd_advertisement_enabled=1)

johannes

