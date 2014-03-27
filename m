Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ee.oulu.fi ([130.231.61.23]:47097 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786AbaC0NjD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 09:39:03 -0400
Received: from [130.231.161.26] (wlan-161-26.oulu.fi [130.231.161.26])
	(authenticated bits=0)
	by ee.oulu.fi (8.14.4/8.14.4) with ESMTP id s2RDBGch025079
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 27 Mar 2014 15:11:16 +0200
Message-ID: <53342374.7010602@ee.oulu.fi> (sfid-20140327_143908_623885_3E8F95C2)
Date: Thu, 27 Mar 2014 15:11:16 +0200
From: =?ISO-8859-1?Q?Pekka_Pietik=E4inen?= <pp@ee.oulu.fi>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [linux-firmware] Bump carl9170 1.9.6 -> 1.9.9?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux-firmware seems to ship an oldish carl9170-1.fw, which seems to
work ok except for spewing a lot of

"[1889329.659407] ieee80211 phy0: invalid plcp cck rate (0)." messages.

Grabbing 1.9.9 seems to make them go away and the driver works just as
well :-)

Any chance of someone bumping the version so the newer firmware gets
shipped by distros?


