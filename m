Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3BMNdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 08:33:24 -0500
Message-ID: <1360762400.8868.10.camel@jlt4.sipsolutions.net> (sfid-20130213_143332_496430_4EB0C4B5)
Subject: Re: [PATCH] cfg80211: configuration for WoWLAN over TCP
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Date: Wed, 13 Feb 2013 14:33:20 +0100
In-Reply-To: <1360596853-13610-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_163429_244766_66451F64)
References: <1360596853-13610-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130211_163429_244766_66451F64)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 16:34 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Intel Wireless devices are able to make a TCP connection
> after suspending, sending some data and waking up when
> the connection receives wakeup data (or breaks). Add the
> WoWLAN configuration and feature advertising API for it.

Applied.

johannes

