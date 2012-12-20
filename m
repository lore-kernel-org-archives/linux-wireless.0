Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2LTL3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:29:43 -0500
Message-ID: <1356003003.10029.5.camel@jlt4.sipsolutions.net> (sfid-20121220_122947_049822_0B735184)
Subject: Re: [PATCH] mac82011: use frame control to differentiate probe
 resp/beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 20 Dec 2012 12:30:03 +0100
In-Reply-To: <1355253494-23118-1-git-send-email-johannes@sipsolutions.net> (sfid-20121211_201757_296159_60A776B2)
References: <1355253494-23118-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121211_201757_296159_60A776B2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 20:18 +0100, Johannes Berg wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> The probe response/beacon management frame RX code passes a
> bool parameter to differentiate beacons and probe responses.
> This is useless since we have the frame and can thus use its
> frame control field. Moreover it is buggy since there is one
> call to ieee80211_rx_bss_info with a beacon frame that is
> indicated as a probe response, which is also fixed by using
> the frame control field, so do that.

Applied.

johannes

