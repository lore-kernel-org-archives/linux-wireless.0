Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:41347 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760706AbXGaW2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 18:28:13 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id D18741804B256
	for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 23:28:11 +0100 (BST)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 4EB1C104B2
	for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 22:28:16 +0000 (UTC)
Message-ID: <46AFB779.4040003@warmcat.com>
Date: Tue, 31 Jul 2007 23:28:09 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Rate control over multiple devices
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

Just seemed a little strange, maybe it is perfectly fine.

iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
PM: Adding info for No Bus:phy0
PM: Adding info for No Bus:wmaster0
wmaster0: Selected rate control algorithm 'iwl-3945-rs'

...but then we add an rt73usb...

PM: Adding info for No Bus:phy1
PM: Adding info for No Bus:wmaster1
wmaster1: Selected rate control algorithm 'iwl-3945-rs' <----
PM: Adding info for No Bus:wlan1
usbcore: registered new interface driver rt73usb

-Andy
