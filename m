Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3DZOL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 10:11:57 -0400
Message-ID: <1366985513.8295.10.camel@jlt4.sipsolutions.net> (sfid-20130426_161201_039179_76312B45)
Subject: Re: [PATCH] mac80211 allow HT override of ampdu factor/density
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 26 Apr 2013 16:11:53 +0200
In-Reply-To: <1365522579-20771-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130409_174951_558534_9705BDF1)
References: <1365522579-20771-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20130409_174951_558534_9705BDF1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-09 at 17:49 +0200, Simon Wunderlich wrote:
> In the current implementation, amdpu changes are applied to own_cap,
> but never actually applied to the stations ht settings, leaving these
> overrides without effect.
> 
> Fix this by using the minimum (factor) or maximum (density) of the
> respective remote and own ampdu values.

Applied, sorry I missed this.

> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---
> This seems to be regression, as this patch was not required in 3.7, most
> probably "mac80211: fix HT capability overrides for AP station".

If it's important to you, please take care of stable for yourself :)

johannes

