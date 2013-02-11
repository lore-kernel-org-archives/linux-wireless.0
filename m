Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:51:06 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rua-0000lo-Vr
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:51:05 +0100
Message-ID: <1360583463.8738.24.camel@jlt4.sipsolutions.net> (sfid-20130211_125251_453980_884BF77C)
Subject: Re: [PATCH] mac80211: remove IEEE80211_HW_SCAN_WHILE_IDLE
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:51:03 +0100
In-Reply-To: <1360227489-11145-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_095751_187755_D548B602)
References: <1360227489-11145-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130207_095751_187755_D548B602)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 09:58 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are only a few drivers that use HW scan, and
> all of those don't need a non-idle transition before
> starting the scan -- some don't even care about idle
> at all. Remove the flag and code associated with it.
> 
> The only driver that really actually needed this is
> wl1251 and it can just do it itself in the hw_scan
> callback -- implement that.

Applied.

johannes

