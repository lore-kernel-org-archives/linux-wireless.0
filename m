Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab3BDPkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:40:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2O9v-000337-IE
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:40:39 +0100
Message-ID: <1359992464.10311.20.camel@jlt4.sipsolutions.net> (sfid-20130204_164043_439631_C34033CC)
Subject: Re: [PATCH] cfg80211: remove unused cfg80211_get_mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:41:04 +0100
In-Reply-To: <1359532505-25658-1-git-send-email-johannes@sipsolutions.net> (sfid-20130130_085448_265760_6247680B)
References: <1359532505-25658-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130130_085448_265760_6247680B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 08:55 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> As Thomas pointed out, cfg80211_get_mesh() is
> unused and can be removed.

Applied.

johannes

