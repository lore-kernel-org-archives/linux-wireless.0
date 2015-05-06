Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57549 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbbEFMsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 08:48:21 -0400
Message-ID: <1430916497.1954.0.camel@sipsolutions.net> (sfid-20150506_144827_438710_5D4110FC)
Subject: Re: [PATCH v3] cfg80211: Allow GO concurrent relaxation after BSS
 disconnection
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Wed, 06 May 2015 14:48:17 +0200
In-Reply-To: <1430142736-24032-1-git-send-email-ilan.peer@intel.com> (sfid-20150427_155022_871329_5457BC68)
References: <1430142736-24032-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150427_155022_871329_5457BC68)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-27 at 16:52 +0300, Ilan Peer wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> If a P2P GO was allowed on a channel because of the GO concurrent
> relaxation, i.e., another station interface was associated to an AP on
> the same channel or the same UNII band, and the station interface
> disconnected from the AP, allow the following use cases unless the
> channel is marked as indoor only and the device is not operating in an
> indoor environment:
> 
> 1. Allow the P2P GO to stay on its current channel. The rationale behind
>    this is that if the channel or UNII band were allowed by the AP they
>    could still be used to continue the P2P GO operation, and avoid connection
>    breakage.
> 2. Allow another P2P GO to start on the same channel or another channel
>    that is in the same UNII band as the previous instantiated P2P GO.

Applied.

johannes

