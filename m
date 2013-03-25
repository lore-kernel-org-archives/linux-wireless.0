Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab3CYNnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 09:43:05 -0400
Message-ID: <1364218979.17540.1.camel@jlt4.sipsolutions.net> (sfid-20130325_144313_043750_ACC33088)
Subject: Re: [PATCH] mac80211: allow drivers to set default uAPSD parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Mon, 25 Mar 2013 14:42:59 +0100
In-Reply-To: <1363954747-29314-1-git-send-email-johannes@sipsolutions.net> (sfid-20130322_131916_578516_B55AA7C5)
References: <1363954747-29314-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130322_131916_578516_B55AA7C5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-22 at 13:19 +0100, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> mac80211 currently sets uAPSD parameters to have VO AC trigger-
> and delivery-enabled, with maximum service period length.
> 
> Allow drivers to change these default settings since different
> uAPSD client implementations may handle errors differently and
> be able to recover from some errors.
> 
> Note: some APs may not function correctly if one or all ACs are
> trigger- and delivery-enabled, see
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/93577.
> We retested with this AP and later firmware doesn't have this
> bug any more.

Applied.

johannes

