Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58595 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbbAFKgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:36:00 -0500
Message-ID: <1420540556.1966.11.camel@sipsolutions.net> (sfid-20150106_113605_122847_6B6B2E30)
Subject: Re: [PATCH] cfg80211: add extensible feature flag attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 06 Jan 2015 11:35:56 +0100
In-Reply-To: <1419350119-29166-1-git-send-email-arend@broadcom.com>
References: <1419350119-29166-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-23 at 16:55 +0100, Arend van Spriel wrote:
> From: Gautam Kumar Shukla <gautams@broadcom.com>
> 
> With the wiphy::features flag being used up this patch adds a
> new field wiphy::ext_features. Considering extensibility this
> new field is declared as a byte array. This extensible flag is
> exposed to user-space by NL80211_ATTR_EXT_FEATURES.

Since it's quite clear that *somebody* will soon use this, I've applied
it now.

Thanks.

johannes

