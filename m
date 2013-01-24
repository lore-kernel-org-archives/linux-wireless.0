Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3AXOns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 09:43:48 -0500
Message-ID: <1359038650.4639.7.camel@jlt4.sipsolutions.net> (sfid-20130124_154355_943240_F8EA82A0)
Subject: Re: [PATCH] mac80211: provide the vif in rssi_callback
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 24 Jan 2013 15:44:10 +0100
In-Reply-To: <1359028932-14244-1-git-send-email-johannes@sipsolutions.net> (sfid-20130124_130152_059598_45E65AE2)
References: <1359028932-14244-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130124_130152_059598_45E65AE2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-24 at 13:02 +0100, Johannes Berg wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> Since drivers can support several BSS / P2P Client
> interfaces, the rssi callback needs to inform the driver
> about the interface teh rssi event relates to.
> 

Applied.

johannes

