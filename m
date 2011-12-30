Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx5.portal.onet.pl ([213.180.147.149]:55766 "EHLO
	mx5.portal.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1L3UL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 15:11:27 -0500
Received: from pf14.m5r2.onet ([10.174.32.45]:44318)
	by mx5.portal.onet.pl with esmtp (Exim 4.63)
	(envelope-from <forlab@op.pl>)
	id 1RgiLY-0004IR-R6
	for linux-wireless@vger.kernel.org; Fri, 30 Dec 2011 20:42:32 +0100
Received: from localhost ([127.0.0.1] helo=ps1.test.onet.pl)
	by pf14.m5r2.onet with smtp (Exim 4.50)
	id 1RgiLY-0007Df-Fb
	for linux-wireless@vger.kernel.org; Fri, 30 Dec 2011 20:42:32 +0100
To: linux-wireless@vger.kernel.org
From: forlab@op.pl
Date: Fri, 30 Dec 2011 20:42:32 +0100
Content-Type: text/plain; charset=US-ASCII
Subject: ipw2200 problem
Mime-Version: 1.0
Message-Id: <E1RgiLY-0007Df-Fb@pf14.m5r2.onet> (sfid-20111230_211135_238269_8EBD7968)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
I'm having problems using this adapter Intel Corporation PRO/Wireless 2915ABG [Calexico2] with backtrack 5. After I

dmesg | grep error

 the only error message I get is this:
[   38.771895] ipw2200: probe of 0000:03:03.0 failed with error -5

From:
dmesg | grep ipw2200
[   38.628681] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
[   38.628687] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   38.628802] ipw2200 0000:03:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   38.628832] ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
[   38.771793] ipw2200: ipw2200-bss.fw request_firmware failed: Reason -2
[   38.771800] ipw2200: Unable to load firmware: -2
[   38.771804] ipw2200: failed to register network device
[   38.771846] ipw2200 0000:03:03.0: PCI INT A disabled
[   38.771895] ipw2200: probe of 0000:03:03.0 failed with error -5

I searched the web, but no help there.... Any idea?

regards
Alex
