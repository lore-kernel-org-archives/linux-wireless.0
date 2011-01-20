Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:45579 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab1ATHWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 02:22:22 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0K7MIRK020649
	for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 02:22:19 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id A697E984E6
	for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 02:22:17 -0500 (EST)
Message-ID: <4D37E2A9.6010209@lockie.ca>
Date: Thu, 20 Jan 2011 02:22:17 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k problem with kernel 2.6.37
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
mem=0xffffc90001880000, irq=17

I get few or no results when I do
iwlist wlan1 scan with kernel 2.6.37

but it is consistently good with kernel 2.6.36.2

Is there a way to compare the kernel configs to make sure I didn't
change anything?
