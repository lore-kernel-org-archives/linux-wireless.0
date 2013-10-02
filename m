Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41346 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3JBR7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 13:59:44 -0400
Received: by mail-lb0-f180.google.com with SMTP id q8so1038401lbi.25
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 10:59:42 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Oct 2013 19:59:42 +0200
Message-ID: <CANMdSOx6kx5G5CPqO566StYpLTvC52qBi1mAXqZY77zSAZE-hQ@mail.gmail.com> (sfid-20131002_195948_921194_983A35F5)
Subject: [ath3k] Support for Asus BT USB dongle (0cf3:3005)
From: Daniel Kamil Kozar <dkk089@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
The Bluetooth dongle installed inside my Asus K53SV laptop seems to be
unsupported. The USB VID:PID is 0cf3:3005, and it's identified by
lsusb as the following :

Bus 001 Device 006: ID 0cf3:3005 Atheros Communications, Inc. AR3011 Bluetooth

However, I didn't see the VID:PID mentioned anywhere in the source of
ath3k. After adding the device's identifier to the source, thus
forcing it to be recognized as an "Atheros AR3011 with sflash
firmware", I got the following message from the driver :

ath3k: probe of 1-1.1:1.0 failed with error -32

How could I help with developing the support for this device?

Kind regards,
-dkk
