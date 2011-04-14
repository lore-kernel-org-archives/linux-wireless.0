Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46041 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1DNL5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 07:57:45 -0400
Received: by bwz15 with SMTP id 15so1301782bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 04:57:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
 <201104131843.57676.chunkeey@googlemail.com> <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 13:57:04 +0200
Message-ID: <BANLkTiniLthxh6iUyzLZ+WHCbUvJ6gP+Gw@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

btw, I shortened my hostapd config to

interface=wlan0
driver=nl80211
ssid=lesiuk
channel=7
hw_mode=g
ieee80211n=1
wme_enabled=1
ht_capab=[HT40-][SHORT-GI-40]

And I see that as 75 mbps network.
