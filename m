Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49333 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbXHKDZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 23:25:12 -0400
Message-ID: <46BD2C17.4000702@lwfinger.net>
Date: Fri, 10 Aug 2007 22:25:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: How to use software encryption with WEP and mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What do I need to do to get mac80211 to do software encryption for WEP? My port of the PHY code from 
bcm43xx and the mac80211 front end works with WPA encryption. With WEP, it authenticates and 
associates, but never gets an IP number from DHCP. That indicates to me that the encryption is not 
set up correctly. I looked through the various definitions in include/net/mac80211.h, but nothing 
seems to apply.

Thanks,

Larry
