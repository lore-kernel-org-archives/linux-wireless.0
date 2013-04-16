Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3DPNaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 09:30:25 -0400
Message-ID: <1366119019.8244.13.camel@jlt4.sipsolutions.net> (sfid-20130416_153029_279161_7C91AE9A)
Subject: Re: [PATCH] mac80211: remove warning from ieee80211_beacon_loss
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Tue, 16 Apr 2013 15:30:19 +0200
In-Reply-To: <1365623673-2368-1-git-send-email-johannes@sipsolutions.net> (sfid-20130410_215447_644627_5CA90C05)
References: <1365623673-2368-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130410_215447_644627_5CA90C05)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 21:54 +0200, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> Currently, mac80211 assumes that connection monitor offload
> for BSS station implies that the device:
> - sends periodic keep alive packets to associated AP
> - monitors missed beacons
> - actively probes the AP in case of missed beacons

Applied.

johannes

