Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3KFLAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 06:00:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ve0qd-0002Hl-RJ
	for linux-wireless@vger.kernel.org; Wed, 06 Nov 2013 12:00:32 +0100
Message-ID: <1383735629.14307.31.camel@jlt4.sipsolutions.net> (sfid-20131106_120035_348862_E2809C4E)
Subject: Re: [PATCH] cfg80211: add missing break in cfg80211_get_chan_state()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 12:00:29 +0100
In-Reply-To: <1382969320-25660-1-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150847_088918_561EFC7C)
References: <1382969320-25660-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131028_150847_088918_561EFC7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 15:08 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Improve readability of the function by adding the break,
> there's no functional impact but it's confusing to fall
> through.

Applied.

johannes

