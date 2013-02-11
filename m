Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:50:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4ruG-0000ky-FO
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:50:44 +0100
Message-ID: <1360583442.8738.23.camel@jlt4.sipsolutions.net> (sfid-20130211_125052_901296_A6A6CDD2)
Subject: Re: [PATCH] mac80211: remove dynamic PS driver interface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:50:42 +0100
In-Reply-To: <1360188507-25819-1-git-send-email-johannes@sipsolutions.net> (sfid-20130206_230815_828308_0DE52B79)
References: <1360188507-25819-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130206_230815_828308_0DE52B79)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 23:08 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The functions were added for some sort of Bluetooth
> coexistence, but aren't used, so remove them again.

Applied.

johannes

