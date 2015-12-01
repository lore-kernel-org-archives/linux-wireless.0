Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43842 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbbLAIcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 03:32:17 -0500
Message-ID: <1448958732.2977.0.camel@sipsolutions.net> (sfid-20151201_093220_379052_B3FE9AEF)
Subject: Re: [PATCH] mac80211: allow drivers to report (non-)monitor frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Dec 2015 09:32:12 +0100
In-Reply-To: <CAPGg_YBwPP0n23gJ1o+_jV98MKrCd5MGYShrbyRt0-56Y5Q-8g@mail.gmail.com> (sfid-20151201_090735_348723_04EE68C9)
References: <1448888094-2707-1-git-send-email-grzegorz.bajorski@tieto.com>
	 <1448889271.3957.2.camel@sipsolutions.net>
	 <CAPGg_YBwPP0n23gJ1o+_jV98MKrCd5MGYShrbyRt0-56Y5Q-8g@mail.gmail.com>
	 (sfid-20151201_090735_348723_04EE68C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-12-01 at 09:07 +0100, Grzegorz Bajorski wrote:
> already sent in [PATCH] ath10k: deliver mgmt frames from htt to
> monitor vifs only.
> 

I see. Perhaps you can resend this patch with a bit of a description of
why you'd want that?

johannes
