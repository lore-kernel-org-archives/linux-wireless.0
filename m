Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab2LTLR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:17:58 -0500
Message-ID: <1356002298.10029.4.camel@jlt4.sipsolutions.net> (sfid-20121220_121805_897490_B64FF2BB)
Subject: Re: [PATCH] cfg80211: adjacent 80+80 MHz channel segments are
 invalid
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Felix Bitterli <felixb@qca.qualcomm.com>
Date: Thu, 20 Dec 2012 12:18:18 +0100
In-Reply-To: <1355440804-19655-1-git-send-email-johannes@sipsolutions.net> (sfid-20121214_001948_366263_8E9860D5)
References: <1355440804-19655-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121214_001948_366263_8E9860D5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 00:20 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In that case, it's really a 160 MHz channel, so disallow
> this configuration.

Applied.

johannes

