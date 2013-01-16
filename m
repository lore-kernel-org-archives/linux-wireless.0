Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3APOSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 09:18:21 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TvToq-0000S4-H4
	for linux-wireless@vger.kernel.org; Wed, 16 Jan 2013 15:18:20 +0100
Message-ID: <1358345925.22862.12.camel@jlt4.sipsolutions.net> (sfid-20130116_151824_687407_7985A2EC)
Subject: Re: [PATCH] mac80211: fix resume from WoWLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 15:18:45 +0100
In-Reply-To: <1358173284-18342-1-git-send-email-johannes@sipsolutions.net> (sfid-20130114_152102_496746_2FB56243)
References: <1358173284-18342-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130114_152102_496746_2FB56243)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-14 at 15:21 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> My commit 529ba6e9313dbe60dab7e72c6fdf647a012e9f5b
> ("mac80211: clean up association better in suspend")
> introduced a bug when resuming from WoWLAN when a
> device reset is desired. This case must not use the
> suspend_bss_conf as it hasn't been stored.

Applied.

johannes

