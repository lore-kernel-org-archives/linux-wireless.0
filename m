Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41650 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab2JWUvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 16:51:46 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so5984224iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2012 13:51:45 -0700 (PDT)
Message-ID: <5087035E.9010609@lwfinger.net> (sfid-20121023_225200_072781_774318BE)
Date: Tue, 23 Oct 2012 15:51:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend Van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Driver for USB device with ID 050d:615a
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend and Franky,

I recently purchased a Belkin N600 DB USB dongle on Ebay. I wanted to get the 
model with a Realtek RTL8192DU chip. Instead I got a version with a Broadcom 
chip, which lsusb identifies as

Bus 001 Device 005: ID 050d:615a Belkin Components F7D4101 / F9L1101 802.11abgn 
Wireless Adapter [Broadcom BCM4323]

I have since acquired a different device with the Realtek chip, thus I could 
return the Belkin device; however, the cost was minimal and I will keep it if 
there is a driver for it. Is it a brcmfmac device that is not yet in the device 
tables, or is it some other sort of unit that may never be supported under Linux?

Thanks,

Larry
