Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:49615 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaEZSSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 14:18:25 -0400
Date: Mon, 26 May 2014 14:18:23 -0400 (EDT)
From: =?UTF-8?Q?Fran=C3=A7ois_Gervais?= <fgervais@brioconcept.com>
Reply-To: =?UTF-8?Q?Fran=C3=A7ois_Gervais?= <fgervais@brioconcept.com>
To: linux-wireless@vger.kernel.org
Message-ID: <2051465131.580554.1401128304011.open-xchange@email.1and1.com> (sfid-20140526_201831_148505_B7A3B78F)
In-Reply-To: <455804885.580074.1401127662835.open-xchange@email.1and1.com>
References: <455804885.580074.1401127662835.open-xchange@email.1and1.com>
Subject: rtl8192cu in AP mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Could someone confirm if the the AP mode with hostapd is still unsupported with
the rtl8192cu driver? I saw on the mailing archive that it's not supported but I
also saw that beacon doesn't get sent and using my current setup it does so I'm
not sure if what I read stands anymore.

Right now my current setup is the following:

- Hostapd 2.1
- Driver NL80211 with libnl 2.0
- rtl8192cu backport 3.15-rc1-1 (backported to kernel 3.2)

Using this setup I see the beacon being sent but I can't connect to it event
when using no encryption.

Please confirm if this behavior is expected or not.

Thanks
