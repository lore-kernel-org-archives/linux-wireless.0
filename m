Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab3KFLBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 06:01:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ve0ru-0002JR-Ou
	for linux-wireless@vger.kernel.org; Wed, 06 Nov 2013 12:01:50 +0100
Message-ID: <1383735708.14307.33.camel@jlt4.sipsolutions.net> (sfid-20131106_120155_781814_2A6C3653)
Subject: Re: [PATCH] mac80211: verify ieee80211_key_replace() arguments
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 12:01:48 +0100
In-Reply-To: <1383037351-18687-1-git-send-email-johannes@sipsolutions.net> (sfid-20131029_100242_424137_47FDCB81)
References: <1383037351-18687-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131029_100242_424137_47FDCB81)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-29 at 10:02 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no code calling ieee80211_key_replace() with both
> arguments NULL and it wouldn't make sense, but in the
> interest of maintainability add a warning for it. As a
> side effect, this also shuts up a smatch warning.
> 

Applied

johannes

