Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3HLMLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 08:11:35 -0400
Message-ID: <1376309491.11514.18.camel@jlt4.sipsolutions.net> (sfid-20130812_141138_169835_F0529940)
Subject: Re: [PATCH 1/2] cfg80211: add wdev to testmode cmd
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Date: Mon, 12 Aug 2013 14:11:31 +0200
In-Reply-To: <1375780347-1062-1-git-send-email-johannes@sipsolutions.net> (sfid-20130806_111238_467049_76C71241)
References: <1375780347-1062-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130806_111238_467049_76C71241)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-06 at 11:12 +0200, Johannes Berg wrote:
> From: David Spinadel <david.spinadel@intel.com>
> 
> To allow drivers to implement per-interface testmode operations
> more easily, pass a wdev pointer if any identification for one
> was given from userspace. Clean up the code a bit while at it.

Applied both.

johannes

