Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2GBMsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 08:48:36 -0400
Message-ID: <1341233314.19642.4.camel@jlt3.sipsolutions.net> (sfid-20120702_144839_344037_66C94B46)
Subject: Re: [PATCH] mac80211: allow calling ieee80211_ap_probereq_get()
 during auth/assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Jul 2012 14:48:34 +0200
In-Reply-To: <1340884993-31432-1-git-send-email-eliad@wizery.com> (sfid-20120628_140255_827376_5D44A776)
References: <1340884993-31432-1-git-send-email-eliad@wizery.com>
	 (sfid-20120628_140255_827376_5D44A776)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 15:03 +0300, Eliad Peller wrote:
> Drivers might need getting the probe request
> (e.g. in order to extract the ssid) even during
> auth/assoc.
> 
> Make ieee80211_ap_probereq_get() support it
> by considering auth_data/assoc_data as well.

Applied.

johannes

