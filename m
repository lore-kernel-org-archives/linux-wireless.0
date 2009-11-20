Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbZKTA6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 19:58:32 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2009 16:58:39 -0800
Subject: master-2009-11-19 busted? can't hold network connection for more
 than 1 second
From: Felix Bitterli <Felix.Bitterli@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Thu, 19 Nov 2009 16:58:38 -0800
Message-ID: <1258678718.5323.8.camel@darkslate>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

does anybody else see this?(sorry I can't bisect today, might have time
tomorrow)

Wireless testing kernel master-2009-11-19 can't hold a network
connection for more than 1 second, master-2009-11-18 is fine.

H/W Thinkpad T43, Atheros AR9280 Rev:2 mem=0xf89e0000, irq=21

Network office Wpa2/psk, tons of traffic/aps/clients.

Thanks guys.
Felix

