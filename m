Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60966 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755783AbZAWCIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 21:08:42 -0500
Message-ID: <4979269F.1060500@lwfinger.net> (sfid-20090123_030847_667385_46CAAB30)
Date: Thu, 22 Jan 2009 20:08:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alina Friedrichsen <x-alina@gmx.net>
CC: John Linville <linville@tuxdriver.com>, samuel@sortiz.org,
	Kalle Valo <kalle.valo@iki.fi>, maximlevitsky@gmail.com,
	wireless <linux-wireless@vger.kernel.org>
Subject: Regression caused by commit e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the commit of the subject, my b43 and p54usb devices stopped working. They could
associate and authenticate with my WPA2 network, but never finish the DHCP connection and
get an IP address. Surprisingly, my rtl8187 devices continued to work.

Please excuse the second sending of this. I missed wireless the first time.

Larry

