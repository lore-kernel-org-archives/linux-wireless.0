Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:62225 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbbBTRga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 12:36:30 -0500
Received: by mail-ob0-f178.google.com with SMTP id uz6so25493014obc.9
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 09:36:30 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Feb 2015 09:36:29 -0800
Message-ID: <CAACrVkg-_CZsS_znKEscnmAMOSbSmkVLmR3ezLDKhCoKx2xxHg@mail.gmail.com> (sfid-20150220_183635_126851_2A6D4C89)
Subject: General question about Broadcom b43 driver and its source.
From: Tom Cipollone <minertom11551@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello. I am new to this forum but have been designing hardware for 33
years. I am new, however, to wireless software. I have designed
modem/residential gateway boards with BCM63138 and others but not the
software so please forgive what may seem like simpleton questions.

My question concerns the b43 driver. The documentation claims that it
was reverse engineered from the BCM4306 component. I expect that the
4306 documentation is very proprietary because I was not able to find
it even though I have customer access to Broadcom customer support.

1) I have a RT-N16 router, with a BCM4718 WiFi. I expect that the
BCM4718 is backwards compatible with the BCM4306?

2) Where can I find the reverse engineered source code for the b43
driver? I have OpenWrt loaded and have compiled it before loading the
.trx file onto my RT-N16. I have been looking on liinux-wireless but
was referred to kernel-backports.

Thank You
