Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:49885 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759939AbYB0Ubm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 15:31:42 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: RE: Roaming issues: Timeout handling
Date: Wed, 27 Feb 2008 21:30:55 +0100
Message-ID: <008801c8797f$a7576830$0b3ca8c0@gotws1589> (sfid-20080227_203145_495884_944DF325)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
In-Reply-To: <1204134256.6309.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I have split my issues ito individual disussions:

> Timeout handling
> =================
> When any of the ieee80211_authenticate() or ieee80211_associate() 
> function are executed.
> The mac silently set its state to IEEE80211_DISABLED and waits for the 
> wpa_supplicant to timeout its current action.
> 
> I think it would be a good idea to signal to the supplicant that the 
> operation has timeout, and no further action will be taken.
> To speed up the timeout response I had squeezed the supplicant timeout.
>
> How do you signal that? Make a wext event with the BSSID all-zeroes or
something? Sounds ok.johannes
>
> Yeah, a zero-BSSID event would mean "disconnected" or "association failed"
and the supplicant would take over at that point.
>

I can check if zero-BSSID would do it.

/Lars




