Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39189 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbbB1UsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Feb 2015 15:48:21 -0500
Message-ID: <1425156497.2404.0.camel@sipsolutions.net> (sfid-20150228_214826_431907_81964DEA)
Subject: Re: [PATCH] mac80211: send station PMF configuration to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 28 Feb 2015 21:48:17 +0100
In-Reply-To: <1425118096-22089-1-git-send-email-sjegadee@qti.qualcomm.com>
References: <1425118096-22089-1-git-send-email-sjegadee@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-02-28 at 15:38 +0530, SenthilKumar Jegadeesan wrote:
> In HT mode, firmware is not encrypting ADDBA request as PMF
> configuration is not set in peer flags during association.
> 
> Enable mac80211 to provide station PMF configuration to driver.

This commit log makes no sense without more context. Please rewrite it
to be more applicable to mac80211, rather than your (presumably)
combined mac80211/driver. mac80211 has no firmware, after all.

johannes

