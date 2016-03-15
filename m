Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47822 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934659AbcCOMPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 08:15:50 -0400
Message-ID: <1458044118.2871.1.camel@sipsolutions.net> (sfid-20160315_131619_018434_FC7257CE)
Subject: Re: The mac80211 softmac driver subsystem and handling of monitor
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Roger James <roger@beardandsandals.co.uk>,
	linux-wireless@vger.kernel.org
Date: Tue, 15 Mar 2016 13:15:18 +0100
In-Reply-To: <56E7E707.2050900@beardandsandals.co.uk> (sfid-20160315_114224_775256_DBFB4DF0)
References: <56E7E707.2050900@beardandsandals.co.uk>
	 (sfid-20160315_114224_775256_DBFB4DF0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-15 at 10:42 +0000, Roger James wrote:

> ath/ath10k ath/ath9k (both ath9k and ath9k_htc) cw1200
> brcm80211/brcmsmac
> 
> All the others seem to be doing things with NL80211_IFTYPE_MONITOR in
> the vif structure. This seems contradictory.
> 

You should look into the WANT_MONITOR flag. :)

johannes
