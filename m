Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:61800 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3GaGzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 02:55:31 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so140285eae.38
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 23:55:30 -0700 (PDT)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: AP changed bandwidth, new config is  ... changed bandwidth in a way we can't support - disconnect - why? (intel advanced-n 6250)
Date: Wed, 31 Jul 2013 08:55:27 +0200
Cc: ilw@linux.intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201307310855.28080.a.miskiewicz@gmail.com> (sfid-20130731_085534_667847_F735B965)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi.

What could be going on with WRT160NL access point, stock firmware that
my linux (3.10.4) with Intel Corporation Centrino Advanced-N + WiMAX 6250 [Kilmer Peak] (rev 2c)
cannot even connect? The same happened with my earlier Intel 5350 wifi card.

It basically reports:
[79477.496067] eth1: AP 68:7f:74:06:b3:1b changed bandwidth, new config is 2422 MHz, width 1 (2422/0 MHz)
[79477.496072] eth1: AP 68:7f:74:06:b3:1b changed bandwidth in a way we can't support - disconnect

(note I have two wrt160nl here and problem happens with both)

Any hints on why "we can't support" configuration issued by this (common) AP?


[79474.704167] eth1: authenticate with 68:7f:74:06:b3:1b
[79474.708354] eth1: send auth to 68:7f:74:06:b3:1b (try 1/3)
[79474.710051] eth1: authenticated
[79474.712304] eth1: associate with 68:7f:74:06:b3:1b (try 1/3)
[79474.735808] eth1: RX AssocResp from 68:7f:74:06:b3:1b (capab=0x431 status=0 aid=1)
[79474.739952] eth1: associated
[79474.834786] eth1: AP 68:7f:74:06:b3:1b changed bandwidth, new config is 2422 MHz, width 1 (2422/0 MHz)
[79474.834791] eth1: AP 68:7f:74:06:b3:1b changed bandwidth in a way we can't support - disconnect
[79474.877910] cfg80211: Calling CRDA to update world regulatory domain
[79474.880204] cfg80211: World regulatory domain updated:
[79474.880208] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[79474.880210] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[79474.880213] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[79474.880215] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[79474.880217] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[79474.880219] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[79474.880581] cfg80211: Calling CRDA for country: PL
[79474.884514] cfg80211: Regulatory domain changed to country: PL
[79474.884517] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[79474.884520] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[79474.884522] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[79474.884524] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[79474.884526] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[79474.884528] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[79477.468073] eth1: authenticate with 68:7f:74:06:b3:1b
[79477.472240] eth1: send auth to 68:7f:74:06:b3:1b (try 1/3)
[79477.473923] eth1: authenticated
[79477.476176] eth1: associate with 68:7f:74:06:b3:1b (try 1/3)
[79477.480118] eth1: RX AssocResp from 68:7f:74:06:b3:1b (capab=0x431 status=0 aid=1)
[79477.484355] eth1: associated
[79477.496067] eth1: AP 68:7f:74:06:b3:1b changed bandwidth, new config is 2422 MHz, width 1 (2422/0 MHz)
[79477.496072] eth1: AP 68:7f:74:06:b3:1b changed bandwidth in a way we can't support - disconnect
[79477.506470] eth1: deauthenticating from 68:7f:74:06:b3:1b by local choice (reason=1)
[79477.506598] cfg80211: Calling CRDA to update world regulatory domain
[79477.512546] cfg80211: World regulatory domain updated:
[79477.512550] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[79477.512553] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[79477.512556] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[79477.512558] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[79477.512560] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[79477.512562] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[79477.512884] cfg80211: Calling CRDA for country: PL
[79477.516800] cfg80211: Regulatory domain changed to country: PL
[79477.516803] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[79477.516806] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[79477.516808] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[79477.516810] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[79477.516812] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[79477.516814] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[79480.234322] eth1: authenticate with 68:7f:74:06:b6:75
[79480.234333] eth1: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[79480.238466] eth1: send auth to 68:7f:74:06:b6:75 (try 1/3)
[79480.304305] eth1: send auth to 68:7f:74:06:b6:75 (try 2/3)
[79480.325316] eth1: send auth to 68:7f:74:06:b6:75 (try 3/3)
[79480.352770] eth1: authentication with 68:7f:74:06:b6:75 timed out
[79483.409516] eth1: authenticate with 68:7f:74:06:b6:75
[79483.409527] eth1: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[79483.411562] eth1: direct probe to 68:7f:74:06:b6:75 (try 1/3)
[79483.612029] eth1: direct probe to 68:7f:74:06:b6:75 (try 2/3)
[79483.816045] eth1: direct probe to 68:7f:74:06:b6:75 (try 3/3)
[79484.020039] eth1: authentication with 68:7f:74:06:b6:75 timed out

-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
