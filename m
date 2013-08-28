Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:48380 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3H1Hhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 03:37:46 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r7S7biHu023104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 16:37:44 +0900 (JST)
From: Yoshihisa Nakagawa <nakagawa@bu.jp.nec.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ath6kl-devel@qualcomm.com" <ath6kl-devel@qualcomm.com>
Subject: ath6kl p2p_find problem
Date: Wed, 28 Aug 2013 07:30:01 +0000
Message-ID: <43550814D799064E884CBF490F4D3F521D7D8730@BPXM03GP.gisp.nec.co.jp> (sfid-20130828_093752_680574_53CDCFBC)
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm using ath6kl with Ubuntu 13.04, kernel version is 3.8.0-23-generic.

In many cases, ath6kl can't find the other terminals in p2p_find.

I capture Probe Request packet with wireshark. ath6kl's SSID is Broadcast,
another machine's SSID is "DIRECT-".

On Wi-Fi Direct spec says, Each SSID shall begin with the ASCII characters "DIRECT-".

It's a firmware or driver problem ?

dmesg is here:

[    7.979257] ath6kl: Failed to get board file ath6k/AR6003/hw2.1.1/bdata.bin (-2), trying to find default board file.
[    7.980508] ath6kl: WARNING! No proper board file was not found, instead using a default board file.
[    7.980521] ath6kl: Most likely your hardware won't work as specified. Install correct board file!
[    8.485200] ath6kl: temporary war to avoid sdio crc error
[    9.260521] ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144\x01 api 3
[    9.260554] ath6kl: firmware supports: sched-scan,sta-p2pdev-duplex,rsn-cap-override

Thanks,
Yoshihisa NAKAGAWA
