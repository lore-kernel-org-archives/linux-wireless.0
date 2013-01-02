Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3ABKv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 05:51:26 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TqLuv-0004Ek-KE
	for linux-wireless@vger.kernel.org; Wed, 02 Jan 2013 11:51:25 +0100
Message-ID: <1357123911.9839.3.camel@jlt4.sipsolutions.net> (sfid-20130102_115129_608528_78380BB3)
Subject: Re: [PATCH] mac80211: support HT notify channel width action
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 11:51:51 +0100
In-Reply-To: <1356693299-12143-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_121444_315212_961A27CC)
References: <1356693299-12143-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121228_121444_315212_961A27CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-28 at 12:14 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Support the HT notify channel width action frame
> to update the rate scaling about the bandwidth
> the peer can receive in.

Applied.

johannes

