Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:45050 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZESCvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 22:51:04 -0400
Received: from [192.168.1.101] (S0106001cf062885c.vc.shawcable.net [24.82.155.236])
	by mail.holtmann.org (Postfix) with ESMTP id E92D08B547
	for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 04:51:07 +0200 (CEST)
Subject: DHCP broken when using A-band only
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 18 May 2009 19:50:51 -0700
Message-Id: <1242701451.3147.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

so I am running the latest wireless-testing.git tree based on 2.6.30-rc6
and when connecting to my A-band only configured AP, I don't get any
packets through. Even DHCP fails. The only thing I see in dmesg is

[ 3221.246392] wlan0: dropped frame to 00:1f:f3:xx:xx:xx (unauthorized port)

The wireless-testing.git tree based on 2.6.30-rc5 was working fine with
that access point. I was actually happily using the A-band since it is
less busy here. Any ideas why this might broke?

Regards

Marcel


