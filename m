Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3BDPIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:08:54 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2NfB-0002Yi-6q
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:08:53 +0100
Message-ID: <1359990557.10311.6.camel@jlt4.sipsolutions.net> (sfid-20130204_160857_686362_4AAD5A4D)
Subject: Re: [PATCH 1/2] mac80211: send deauth when connection is lost
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:09:17 +0100
In-Reply-To: <1359637562-22399-1-git-send-email-johannes@sipsolutions.net> (sfid-20130131_140546_138447_A35D7420)
References: <1359637562-22399-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130131_140546_138447_A35D7420)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 14:06 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If the driver determines the connection is lost,
> send a deauth frame to the AP anyway just in case
> it still considers the connection alive. The frame
> might not go through, but at least we've tried.

Applied.

johannes

