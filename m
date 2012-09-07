Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2IGISB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:18:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T9tlI-0004v3-FD
	for linux-wireless@vger.kernel.org; Fri, 07 Sep 2012 10:18:00 +0200
Message-ID: <1347005918.4256.1.camel@jlt4.sipsolutions.net> (sfid-20120907_101808_804500_CEBAD2C1)
Subject: Re: [PATCH] wireless: remove obsolete chan no/center freq
 conversion functions
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 10:18:38 +0200
In-Reply-To: <1343144412-8562-1-git-send-email-johannes@sipsolutions.net> (sfid-20120724_174020_200174_ADAAB4D4)
References: <1343144412-8562-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120724_174020_200174_ADAAB4D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-24 at 17:40 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are a number of functions that shouldn't really
> be used when modern functions that take the band are
> available in cfg80211. Remove these, but for now keep
>  * ieee80211_freq_to_dsss_chan and
>  * ieee80211_dsss_chan_to_freq
> as they're used in older drivers.

Applied.

johannes

