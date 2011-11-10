Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1KJIF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 03:05:29 -0500
Subject: Re: [PATCH 01/28] iwlagn: add P2P NoA to probe responses
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1320885571-19122-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023338_740420_996794F6)
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1320885571-19122-2-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20111110_023338_740420_996794F6)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 09:05:22 +0100
Message-ID: <1320912322.3967.1.camel@jlt3.sipsolutions.net> (sfid-20111110_090533_001607_1DE0F2A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 16:39 -0800, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Whether to use NoA or not is entire controlled
> by the uCode right now, and it also adds the
> attribute to beacons. We do need to add it to
> probe responses in the driver though.
> 
> Keep track of the NoA notification from the
> uCode and add the data to probe responses when
> such are transmitted. Use RCU to manage the
> lifetime.

Patch 25 should have been merged into this one :)

johannes

