Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm47.bullet.mail.ne1.yahoo.com ([98.138.120.54]:21479 "EHLO
	nm47.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbaFGAlM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 20:41:12 -0400
Message-ID: <1402101493.72717.YahooMailBasic@web75002.mail.tw1.yahoo.com> (sfid-20140607_024324_395064_2C48FF27)
Date: Sat, 7 Jun 2014 08:38:13 +0800 (CST)
From: Frank Chen <mbuf888@yahoo.com.tw>
Subject: use nl80211 to receive normal data frames to support CAPWAP like split-MAC architecture.
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, as I read through mac80211/nl80211 source code, it seems as of now nl80211/mac80211 only supports mgmt frame Tx/Rx. I'd like to be able to  subscribe Rx decrypted data frames on per BSS/STA basis via nl80211, and on Tx path to allow raw data frames injection from nl80211 as well. My interest is to receive and transmit all non +Null data frames from user level application. Both Tx/Rx I'd like to skip linux bridge and TCP/IP stack completely. 

I know that could be a lot of work since I need to change mac80211 and nl80211 but I just want to ask has anyone tried or seen someone did this before?

Thanks
Frank


