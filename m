Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab3BKO1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 09:27:45 -0500
Message-ID: <1360592857.8738.30.camel@jlt4.sipsolutions.net> (sfid-20130211_152748_610421_39B89450)
Subject: Re: [BUG] Beacon loss event every second
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 15:27:37 +0100
In-Reply-To: <5118F682.8000502@neratec.com> (sfid-20130211_145326_243072_B10AE6CB)
References: <5118F682.8000502@neratec.com>
	 (sfid-20130211_145326_243072_B10AE6CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 14:47 +0100, Wojciech Dubowik wrote:
> Hello,
> 
>    On latest testing and mac80211-next I am getting beacon loss event 
> every second even when connection is perfect.
> 
> Feb 11 14:49:52 wlanTS kernel: [14148.599482] wlan0: cancelling probereq 
> poll due to a received beacon

> Has somebody already fixed it? Just asking before I start digging in.

I'm not aware of that.

johannes

