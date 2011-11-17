Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm2.bullet.mail.in.yahoo.com ([121.101.151.224]:35203 "HELO
	nm2.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753980Ab1KQPbX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 10:31:23 -0500
Message-ID: <1321543880.78636.YahooMailNeo@web137415.mail.in.yahoo.com> (sfid-20111117_163126_369915_C1052864)
Date: Thu, 17 Nov 2011 21:01:20 +0530 (IST)
From: prakhar vig <aquarian_133@yahoo.co.in>
Reply-To: prakhar vig <aquarian_133@yahoo.co.in>
Subject: mac80211 Queries
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
 
I am new to mac80211, I have few queries regarding the architecture.
Would be highly thnkful if someone can clarify my understanding:
 
1. As per my understanding, all IEs creation for Satellite will be done at WPA Supplicant irrespective of management frame or Action Frame and passed to mac80211 using nl80211 driver and cfg80211, where Management Frame will be created and passed to driver.
 
2. Scanning for satellite will be initiated by Supplicant.
 
Regards,
Prakhar
