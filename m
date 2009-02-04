Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:34195 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120AbZBDXsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:48:55 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: ath5k: problems with wireless network data transfer
Date: Thu, 5 Feb 2009 00:47:43 +0100
Cc: linux-wireless@vger.kernel.org
References: <200902050010.27428.rossi.f@inwind.it> <40f31dec0902041519t5dcab35n19e6a0ec1642eaa5@mail.gmail.com>
In-Reply-To: <40f31dec0902041519t5dcab35n19e6a0ec1642eaa5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200902050047.44133.rossi.f@inwind.it> (sfid-20090205_004900_393184_917CFF4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 February 2009, Nick Kossifidis wrote:

> Can you please post a dmesg output when ath5k loads ?

This is the dmesg output:

cfg80211: Calling CRDA to update world regulatory domain
ath5k 0000:00:0b.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
ath5k 0000:00:0b.0: registered as 'phy0'
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
ath5k phy0: RF5112B multiband radio found (0x36)
udev: renamed network interface wlan0 to ath0
cfg80211: World regulatory domain updated:
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
