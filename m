Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2IEN6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 09:58:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T9G7U-0002Bi-Vp
	for linux-wireless@vger.kernel.org; Wed, 05 Sep 2012 15:58:17 +0200
Message-ID: <1346853535.4364.18.camel@jlt4.sipsolutions.net> (sfid-20120905_155820_427802_F779C9B0)
Subject: Re: [PATCH] mac80211: don't use kerneldoc for
 ieee80211_add_rx_radiotap_header
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 05 Sep 2012 15:58:55 +0200
In-Reply-To: <1346853333-17869-1-git-send-email-johannes@sipsolutions.net> (sfid-20120905_155500_676104_FDD24AF3)
References: <1346853333-17869-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120905_155500_676104_FDD24AF3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-05 at 15:55 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Doing so creates warnings, but the function is internal and
> not part of the 802.11 docbooks, so it from kerneldoc.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied.

johannes

