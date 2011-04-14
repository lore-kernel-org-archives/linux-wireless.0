Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40892 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783Ab1DNSCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 14:02:34 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so1584407bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 11:02:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTingZRChrOtSPbat6D69_nW=6DpADw@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
 <201104131843.57676.chunkeey@googlemail.com> <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
 <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com> <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com>
 <BANLkTingZRChrOtSPbat6D69_nW=6DpADw@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 20:01:53 +0200
Message-ID: <BANLkTikX2b+0m23JZTKWuFzzr3rNmWdnqg@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With hostapd 0.6.9 I have:

Station 74:f0:6d:33:ea:00 (on wlan0)
       inactive time:  10 ms
       rx bytes:       1563761
       rx packets:     18910
       tx bytes:       52327665
       tx packets:     34780
       signal:         -34 dBm
       tx bitrate:     135.0 MBit/s MCS 6 40Mhz short GI

But I can only get 16 mbps max.
