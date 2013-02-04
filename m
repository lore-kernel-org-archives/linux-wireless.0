Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3BDPl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:41:26 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2OAf-00034J-0B
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:41:25 +0100
Message-ID: <1359992510.10311.22.camel@jlt4.sipsolutions.net> (sfid-20130204_164141_533461_3842FA12)
Subject: Re: [PATCH] cfg80211: fix BSS IE allocation comment
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:41:50 +0100
In-Reply-To: <1359637757-31521-1-git-send-email-johannes@sipsolutions.net> (sfid-20130131_140857_707270_C337429D)
References: <1359637757-31521-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130131_140857_707270_C337429D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 14:09 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The comment about allocating the IEs together with
> the BSS struct is no longer true, remove it. Also
> fix a typo in the same area.

Applied.

johannes

