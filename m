Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55642 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1JAOuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 10:50:17 -0400
Received: by wyg34 with SMTP id 34so1885635wyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2011 07:50:16 -0700 (PDT)
Date: Sat, 1 Oct 2011 16:50:07 +0200
From: Loiseau Lucien <loiseau.lucien@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: rt2800pci - ksoftirq takes 100% CPU
Message-ID: <20111001145007.GA2094@loiseau.cc> (sfid-20111001_165027_230256_CC312804)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I experience some trouble with my RaLink RT3090 Wireless 802.11n 1T/1R
PCIe card. I'm trying to set a wireless access point with it. I'm
running a Debian Squeeze with kernel 2.6.32-5-686.

at first i was using the shipped rt2860sta but since it's not a mac80211
driver, i couldn't use hostapd and iwconfig mode master was not working.
I eventually installed different stable version of compat-wireless and
ran the driver rt2800pci. If i could set a running access  point, i
often end with an unloadable module whith a ksoftirq taking 100% of my
CPU. Once this "ksoftirq" problem arises, there is no way to  unload the
module.

does anyone ever experience this card and make it work fine ?
I can provide more information if needed.

Lucien.



