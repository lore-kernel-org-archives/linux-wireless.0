Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150Ab3CDPhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:37:20 -0500
Message-ID: <1362411435.21028.28.camel@jlt4.sipsolutions.net> (sfid-20130304_163722_777465_8FFEBD6D)
Subject: Re: [PATCH] mac80211: restrict peer's VHT capabilities to own
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com
Date: Mon, 04 Mar 2013 16:37:15 +0100
In-Reply-To: <1362139980-31675-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_131312_073764_800ADD2C)
References: <1362139980-31675-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130301_131312_073764_800ADD2C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 13:13 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Implement restricting peer VHT capabilities to the device's own
> capabilities. This is useful when a single driver supports more
> than one device and the devices have different capabilities
> (often they will differ in the number of spatial streams), but
> in particular is also necessary for VHT capability overrides to
> work correctly -- otherwise it'd be possible to e.g. advertise,
> due to overrides, that TX-STBC is not supported, but then still
> use it to TX to the AP because it supports RX-STBC.

Applied.

johannes

