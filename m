Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:48183 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab1AXI3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 03:29:41 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0O8Tafg010545
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 03:29:37 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 8CD7D98479
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 03:29:36 -0500 (EST)
Message-ID: <4D3D3870.2090408@lockie.ca>
Date: Mon, 24 Jan 2011 03:29:36 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Failed to stop TX DMA! is new
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get few or no results when I do
iwlist wlan1 scan with kernel 2.6.37

I tried kernel-2.6.38-rc2

ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
mem=0xffffc900017a0000, irq=18
ath: Failed to stop TX DMA in 100 msec after killing last frame
ath: Failed to stop TX DMA!

I noticed those Failed to stop are new messages.

kernel-2.6.36-2 works fine.

