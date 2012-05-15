Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:4314 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756534Ab2EOHS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 03:18:26 -0400
Received: from mail138-va3 (localhost [127.0.0.1])	by
 mail138-va3-R.bigfish.com (Postfix) with ESMTP id 7025122018F	for
 <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:18:20 +0000 (UTC)
Received: from VA3EHSMHS022.bigfish.com (unknown [10.7.14.253])	by
 mail138-va3.bigfish.com (Postfix) with ESMTP id 9E3791E0048	for
 <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:18:18 +0000 (UTC)
Message-ID: <4FB2033B.4070701@netgem.com> (sfid-20120515_091830_714716_4A745538)
Date: Tue, 15 May 2012 09:18:19 +0200
From: "F. LECAILLE" <flc@netgem.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: broadcom 43236B USB module
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have some Wifi USB modules with 43236B Broadcom chipset. I have read on the
linuxwireless dot org website that this chipset is supported by the brcmfmac
*(USB)* driver.

As I am also trying to backport this driver for an embedded device which runs a
2.6.27 kernel, I had a look to the 3.2 kernel sources and especially to the
drivers/net/wireless/brcm80211/brcmfmac directory. But I do not find any
reference to USB stack kernel functions.

How may this work?

Regards.

