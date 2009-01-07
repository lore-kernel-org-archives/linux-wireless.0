Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42401 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZAGRbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 12:31:22 -0500
Received: by bwz14 with SMTP id 14so25898671bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 09:31:20 -0800 (PST)
From: Florian Fainelli <florian@openwrt.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Wake on WLAN with ath5k
Date: Wed, 7 Jan 2009 18:31:14 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901071831.14878.florian@openwrt.org> (sfid-20090107_183126_363040_0203F922)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I just came accross some registers in drivers/net/wireless/ath5k/reg.h 
(startig at line 464) which seem to be used to allow Wake on WLAN using ar5k 
hardware.

Has anyone already tried this ? 

Thanks for your answer.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
