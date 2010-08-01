Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64050 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0HABxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 21:53:14 -0400
Received: by qwh6 with SMTP id 6so827653qwh.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jul 2010 18:53:13 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 1 Aug 2010 11:53:13 +1000
Message-ID: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>
Subject: virtual access poitns (ath5k/mac80211)
From: Ryszard <ryszard99@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

i'm working on a project that requires i can create multiple access
points on the one bit of hardware.  After an insane amount of googling
and reading the lists the closest i've been able to come up with is
something along the lines of:
iw dev wlan0 interface add vap0 type __ap
iw dev wlan0 interface add vap1 type __ap

then using macchanger to assign unique mac addresses.

I've also seen something from March 2009
(http://lwn.net/Articles/321690/) that hints at the functionality
available with the ath9k which gave me a bit of hope!

My question is, is it possible to create multiple virtual access
points with my hardware ( Atheros Communications Inc. AR5413 802.11abg
) and the ath5k/mac80211 drivers (or is there some other method to
achieve what i'm after) ?  i'm not too fussed about different
channels, but different SSID's and WPA keys are a requirement for the
project.

regs
ryszard
