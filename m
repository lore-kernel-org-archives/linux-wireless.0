Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:38097 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZLCXoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 18:44:39 -0500
Received: by iwn1 with SMTP id 1so1295542iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 15:44:46 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Dec 2009 15:44:26 -0800
Message-ID: <43e72e890912031544j7cb8bffav1c1c7d016e740175@mail.gmail.com>
Subject: Broadcom Android bcm4329 open driver
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Henry Ptasinski <henryp@broadcom.com>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Howard M. Harte" <hharte@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case you haven't seen this yet, Broadcom has an open (!) driver on
the Android git tree with support for SDIO/SPI for  bcm4329.

http://tinyurl.com/broadcom-android-bcm4329

The commit log entry dated 2009-10-29 states:

Linux WLAN driver for BCM4329 - Low-Power 802.11n with Bluetooth(R)
2.1+ EDR and FM (Tx and Rx)

  Luis
