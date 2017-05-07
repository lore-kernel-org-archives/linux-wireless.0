Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:36144 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753337AbdEGVvp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 May 2017 17:51:45 -0400
Received: by mail-wr0-f169.google.com with SMTP id l50so30084773wrc.3
        for <linux-wireless@vger.kernel.org>; Sun, 07 May 2017 14:51:44 -0700 (PDT)
Received: from franki.localnet (aauw184.neoplus.adsl.tpnet.pl. [83.6.30.184])
        by smtp.gmail.com with ESMTPSA id i28sm902723ljb.63.2017.05.07.05.19.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 May 2017 05:19:26 -0700 (PDT)
From: Marek =?utf-8?B?RmxvcmlhxYRjenlr?= <marek.florianczyk@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Cubieboard2 + hostapd + 100 wireless devices
Date: Sun, 07 May 2017 14:19:25 +0200
Message-ID: <1946348.9jam7OIK4C@franki> (sfid-20170507_235151_295443_0968D719)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I need to set up such a configuration:
Cubieboard2 with Debian Jessie, Hostapd 2.6 as an AP, usb wifi dongle + 100 
devices with NodeMCU module:
http://www.electrodragon.com/product/esp-12f-esp8266-wifi-board/

I'm using usb wifi dongle based on Ralink RT5370 Wireless Adapter,
after I have switched hostapd network mode to "b" it works quite well (tested 
with 70 devices). Only text commands are going to be send from server to 
devices, so I don't need high speed, I need reliability.

Has someone any experience with such a setup ?
Would one recommend different wifi dongle (maybe more powerful), with different 
chipset?
I have also tested:
https://wikidevi.com/wiki/TP-LINK_TL-WN722N
But according to this info (and my experience)
http://geekofpassage.blogspot.com/2014/07/openwrt-ath9khtc-could-not-add-sta-to.html
There is hardware limit on the number of devices that can be connected to AP.
Any other hints?
This whole setup is supposed to be installed in a bus (double decker), single 
server (AP) and wifi module for each seat.

Best Regards
Marek
