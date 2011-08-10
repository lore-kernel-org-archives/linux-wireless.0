Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1HJNz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:55:56 -0400
Subject: Re: [PATCH 3/4] mac80211: Add HT helper functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2346835.BL4CqEnUDP@alex-1> (sfid-20110808_140943_617659_52176005)
References: <1888623.Vt5VZUN2cU@alex-1>  <2346835.BL4CqEnUDP@alex-1>
	 (sfid-20110808_140943_617659_52176005)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:55:53 +0200
Message-ID: <1312984553.4325.12.camel@jlt3.sipsolutions.net> (sfid-20110810_155559_651114_AF1A2ACE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 14:09 +0200, Alexander Simon wrote:

> +enum nl80211_channel_type ieee80211_ht_info_to_channel_type(
> +					struct ieee80211_ht_info *ht_info)

This isn't used in this patch so you should put it into the other patch.

johannes

