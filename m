Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:48274 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZKWUu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 15:50:28 -0500
Received: from smtp05.web.de (fmsmtp05.dlan.cinetic.de [172.20.4.166])
	by fmmailgate02.web.de (Postfix) with ESMTP id 94664143FD7F9
	for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 21:50:34 +0100 (CET)
Received: from [62.96.140.125] (helo=[172.20.2.20])
	by smtp05.web.de with asmtp (TLSv1:AES128-SHA:128)
	(WEB.DE 4.110 #314)
	id 1NCfrm-0003h5-00
	for linux-wireless@vger.kernel.org; Mon, 23 Nov 2009 21:50:34 +0100
From: Ali Jelveh <jelveh@web.de>
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Subject: ath9k and multiple ssids
Date: Mon, 23 Nov 2009 21:50:34 +0100
References: <4F794DBA-82EF-4254-A874-ADFF05287CF4@web.de>
To: linux-wireless@vger.kernel.org
Message-Id: <D16ADE3A-61E2-4F46-ADD6-D3C8824A9BE9@web.de>
Mime-Version: 1.0 (Apple Message framework v1076)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all!

I'm trying to get multiple ssids to work with hostapd (2.6.31 kernel  
and hostapd v0.6.9, driver=nl80211) thru adding a bss=wlan0_1 and  
ssid=someothername to the config, I get an "Invalid BSSID mask" error  
- so my question is: should this work? or isn't that feature  
implemented in my current wireless driver?

Thanks for your help!

Ali

