Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34776 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdBUGzm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 01:55:42 -0500
Received: by mail-vk0-f50.google.com with SMTP id r136so74215180vke.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2017 22:55:41 -0800 (PST)
To: linux-wireless@vger.kernel.org,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>
From: Xuebing Wang <xbing6@gmail.com>
Subject: [openwrt-devel] [linux-wireless] 802.11s mesh network can not recover
 after connectivity goes low and back up
Message-ID: <5272d739-1ac2-a892-9b52-889fde2861c4@gmail.com> (sfid-20170221_075738_668354_CD21CB46)
Date: Tue, 21 Feb 2017 14:55:37 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Community,

I am using several routers (Atheros AR9331 + OpenWRT) to build a 802.11s 
mesh network. I am having an issue.
-  Linux kernel: 3.18.29
-  OpenWRT version / branch: chaos_calmer
-  Hardware platform: AR9331 with ath9k driver.

Description of the issue:
-  When connectivity of a mesh node is low and connection to other nodes 
is lost. After connectivity is back up again, ping other nodes won't get 
this node to recover to connect to its peers.
-  Test setup: most routers are in one room, with one specific router in 
another room to simulate low connectivity.
-  I use 'iw wlan0 set txpower limit 0' to simulate low connectivity.
-  It's not easy to reproduce, occurrence rate is low.
-  I sometimes put a laptop to the isolated router and "ssh into this 
laptop" to generate some WiFi traffic (possible collisions).

Does anyone see the similar issue? Thanks.

xuebing wang
