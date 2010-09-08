Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59842 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0IHRf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 13:35:26 -0400
Received: by qyk33 with SMTP id 33so299480qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 10:35:25 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Sep 2010 11:35:25 -0600
Message-ID: <AANLkTiksQ3kgagLD5NC0TNALkjQ3kXwdWPeNAManK4DW@mail.gmail.com>
Subject: ar6000 iMX31 2.6.35
From: Badguy Badguy <therealbadguy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

 I am having trouble with the ar6000 driver using a variety of
different Atheros chipped cards.

iMX31 LogicPD
Kernel 2.6.35
SDIO interface

below is a log of what happens.

ar6000_available
BMI Get Target Info: Exit (ver: 0x20000188 type: 0x2)
Serial console prints enabled
Block Size Set: 128 (target address:0x50046C)
ar6000_init() Got WMI @ 0xc3d8fa00.
 Timeout waiting for recv message
Target debug interrupt
 Target Not Available!!
ar6000_avail: register_netdev failed
+ar6000_destroy
ar6000_destroy(): WMI not ready 0xc372a340 0xc3d8fa00
ar6000_destroy(): Shut down WMI
 Attempting to reset target on instance destroy....
-ar6000_destroy


Thanks
