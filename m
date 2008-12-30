Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33085 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYL3BiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 20:38:12 -0500
Received: from hrndva-web19-z02 ([10.128.132.170])
          by hrndva-smta02.mail.rr.com with ESMTP
          id <20081230013810.LISY22134.hrndva-smta02.mail.rr.com@hrndva-web19-z02>
          for <linux-wireless@vger.kernel.org>;
          Tue, 30 Dec 2008 01:38:10 +0000
Message-ID: <20081230013810.R86WV.401393.root@hrndva-web19-z02> (sfid-20081230_023817_975154_F794104C)
Date: Tue, 30 Dec 2008 1:38:09 +0000
From: <lmage11@twcny.rr.com>
To: linux-wireless@vger.kernel.org
Subject: Help debugging unexpected disassociations?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey everyone. I'm using an Intel 4965AGN using the iwlagn driver in 2.6.28. When using a specific AP, my connection is unexpectedly dropping with nothing more than a "wlan0: deauthenticated". Any tips on how I could figure out whether this is the driver's fault or the AP's? Another problem I'm having is that dhcpcd is timing out a lot, usually after trying to reconnect from a connection drop.

The AP is a Linksys WRT54Gv1 with WPA2 and ssid broadcasting enabled.

Thanks!

Ari
