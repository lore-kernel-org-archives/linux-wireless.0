Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbaDVOrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 10:47:43 -0400
Message-ID: <1398178044.4211.9.camel@jlt4.sipsolutions.net> (sfid-20140422_164755_954152_E70578E5)
Subject: Re: [PATCH 03/12] mac80211: minor changes of ieee80211_reconfig()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Apr 2014 16:47:24 +0200
In-Reply-To: <d8410804796e01fe8b4c62aeaca97b791154f585.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065501_034767_D908E586)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <d8410804796e01fe8b4c62aeaca97b791154f585.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065501_034767_D908E586)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:52 +0800, Zhao, Gang wrote:
> Try to update chanctx only if local->use_chanctx is true.

I'm not convinced this part is correct, since the internal channel
context handling also has an effect when the driver doesn't use it.

Have you really thought this through?

johannes


