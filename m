Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:57187 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab1CTVET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 17:04:19 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2KL4H8b015970
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 17:04:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 058FB1E0390
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 17:04:16 -0400 (EDT)
Message-ID: <4D866BD1.9060904@lockie.ca>
Date: Sun, 20 Mar 2011 17:04:17 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: kernel-2.6.36.2 works, later doesn't
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

$ dmesg | grep phy
BIOS-provided physical RAM map:
modified physical RAM map:
phy0: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
mem=0xffffc90001900000, irq=17

This is kernel-2.6.36.2.
The wireless doesn't work on any later kernel that I have tried.
It is very interesting the IRQ is 17 on this kernel but 18 on 2.6.37.3.

