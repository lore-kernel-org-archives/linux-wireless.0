Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35471 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbbAWJw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:52:29 -0500
Message-ID: <1422006746.2728.17.camel@sipsolutions.net> (sfid-20150123_105233_329110_FA6FDE1C)
Subject: Re: [PATCH] nl80211: add an attribute to allow delaying the first
 scheduled scan cycle
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 10:52:26 +0100
In-Reply-To: <1421417049-9087-1-git-send-email-luca@coelho.fi>
References: <1421417049-9087-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-16 at 16:04 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> The userspace may want to delay the the first scheduled scan or
> net-detect cycle.  Add an optional attribute to the scheduled scan
> configuration to pass the delay to be (optionally) used by the driver.

Applied.

> +	NL80211_ATTR_SCHED_SCAN_DELAY,

This attribute needed to be added to the policy - I've done that for you
(this time :) )

johannes

