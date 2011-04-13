Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49788 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1DMIeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 04:34:19 -0400
Received: by bwz15 with SMTP id 15so375139bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 01:34:18 -0700 (PDT)
MIME-Version: 1.0
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Wed, 13 Apr 2011 10:33:38 +0200
Message-ID: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
Subject: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps) MASTER MODE
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have very low connection speeds. Is it normal for that device/driver?

My hostapd.conf:
interface=wlan0
driver=nl80211
ssid=lesiuk
channel=7
hw_mode=g
ieee80211n=1
ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]

macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

beacon_int=100

dtim_period=2
