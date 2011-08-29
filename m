Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1H2NZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 09:25:04 -0400
Subject: Re: [PATCH v2 1/3] nl80211/cfg80211: add WIPHY_FLAG_AP_UAPSD flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314271494-8756-1-git-send-email-eliad@wizery.com> (sfid-20110825_132407_483820_102372B1)
References: <1314271494-8756-1-git-send-email-eliad@wizery.com>
	 (sfid-20110825_132407_483820_102372B1)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 15:25:02 +0200
Message-ID: <1314624302.8959.3.camel@jlt3.sipsolutions.net> (sfid-20110829_152508_840497_1D297CB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 14:24 +0300, Eliad Peller wrote:
> add WIPHY_FLAG_AP_UAPSD flag to indicate uapsd support on
> AP mode.
> 
> Advertise it to userspace by including a new
> NL80211_ATTR_SUPPORT_AP_UAPSD attribute.

I guess it'll help me support this for mac80211 (drivers that don't do
it all in firmware) -- I had a patch that was equivalent to the first
two :)

johannes

