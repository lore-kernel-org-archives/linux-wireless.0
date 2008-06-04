Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:62568 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757565AbYFDTW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 15:22:57 -0400
Message-ID: <4846EB9D.1080303@lwfinger.net> (sfid-20080604_212300_826143_521A5A9C)
Date: Wed, 04 Jun 2008 14:23:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Regression (?) with wireless-testing and mainline 2.6.26-rcX kernels
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I have found what I think is a regression where b43 appears to be connected; 
however, no data can be transferred. Not very much information has been 
logged; however, I think it correlates with a switch from short to long 
barker preamble.

Do you have any suggestions on what should be logged in 
ieee80211_handle_protect_preamb or any other mac80211 routine so that I can 
isolate the problem? I use NM to control the connection and authentication to 
a WPA-PSK TKIP network.

Thanks,

Larry
