Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36251 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbcKUJqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 04:46:20 -0500
Received: by mail-oi0-f52.google.com with SMTP id v84so154378247oie.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 01:46:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQm9DBc_tkQnXwLVuV6dbsEixn73t_TRk1akktTiwRm_0w@mail.gmail.com>
References: <CAHdg3xaCnAp8rgMs3mVYvV6TFadNjwBtCo+rpHgH_-L8JUo-dw@mail.gmail.com>
 <20161120010740.GB3581@localhost> <CA+BoTQm9DBc_tkQnXwLVuV6dbsEixn73t_TRk1akktTiwRm_0w@mail.gmail.com>
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Mon, 21 Nov 2016 10:46:17 +0100
Message-ID: <CAHdg3xZMJw47Zyh9ubawysGqo6N2qcNUXX1o19GyFYOHv8GivA@mail.gmail.com> (sfid-20161121_104624_788513_435731D7)
Subject: Re: ath10k stuck in mesh mode
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Bob Copeland <me@bobcopeland.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bob, Michal, all,

I've just tried your advices (actually I already tried it following
the wireless.wiki.kernel web pages) and I had a look at the syslog
while I was typing the commands
At the beginning I have this
root@MrProper:~# tail -f -n 200 /var/log/syslog
Nov 21 07:53:23 MrProper kernel: [    9.121882] cfg80211: Updating
information on frequency 5260 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.121891] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.121900] cfg80211: Updating
information on frequency 5280 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.121906] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.121913] cfg80211: Updating
information on frequency 5300 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.121923] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.121931] cfg80211: Updating
information on frequency 5320 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.121937] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.121946] cfg80211: Updating
information on frequency 5500 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.121954] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.121963] cfg80211: Updating
information on frequency 5520 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.121972] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.121982] cfg80211: Updating
information on frequency 5540 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.121990] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.121997] cfg80211: Updating
information on frequency 5560 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122004] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122012] cfg80211: Updating
information on frequency 5580 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122021] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122029] cfg80211: Disabling
freq 5600 MHz for good
Nov 21 07:53:23 MrProper kernel: [    9.122038] cfg80211: Disabling
freq 5620 MHz for good
Nov 21 07:53:23 MrProper kernel: [    9.122044] cfg80211: Disabling
freq 5640 MHz for good
Nov 21 07:53:23 MrProper kernel: [    9.122051] cfg80211: Updating
information on frequency 5660 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122058] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122068] cfg80211: Updating
information on frequency 5680 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122077] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122085] cfg80211: Updating
information on frequency 5700 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122094] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122099] cfg80211: Disabling
freq 5720 MHz for good
Nov 21 07:53:23 MrProper kernel: [    9.122110] cfg80211: Updating
information on frequency 5745 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122118] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122125] cfg80211: Updating
information on frequency 5765 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122133] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122141] cfg80211: Updating
information on frequency 5785 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122147] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122156] cfg80211: Updating
information on frequency 5805 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122166] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.122175] cfg80211: Updating
information on frequency 5825 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.122184] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.487186] ath10k_pci
0000:07:00.0: qca988x hw2.0 (0x4100016c, 0x043222ff sub 0000:0000) fw
10.2.4.70.58 fwapi 5 bdapi 1 htt-ver 2.1 wmi-op 5 htt-op 2 cal otp
max-sta 128 raw 1 hwcrypto 1 features no-p2p,raw-mode
Nov 21 07:53:23 MrProper kernel: [    9.487202] ath10k_pci
0000:07:00.0: debug 1 debugfs 1 tracing 0 dfs 1 testmode 1
Nov 21 07:53:23 MrProper kernel: [    9.591528] ath: EEPROM regdomain: 0x0
Nov 21 07:53:23 MrProper kernel: [    9.591537] ath: EEPROM indicates
default country code should be used
Nov 21 07:53:23 MrProper kernel: [    9.591542] ath: doing EEPROM
country->regdmn map search
Nov 21 07:53:23 MrProper kernel: [    9.591553] ath: country maps to
regdmn code: 0x3a
Nov 21 07:53:23 MrProper kernel: [    9.591558] ath: Country alpha2
being used: US
Nov 21 07:53:23 MrProper kernel: [    9.591563] ath: Regpair used: 0x3a
Nov 21 07:53:23 MrProper kernel: [    9.591573] cfg80211: Updating
information on frequency 5180 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591581] cfg80211: (5140000 KHz
- 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591589] cfg80211: Updating
information on frequency 5200 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591597] cfg80211: (5140000 KHz
- 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591603] cfg80211: Updating
information on frequency 5220 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591611] cfg80211: (5140000 KHz
- 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591617] cfg80211: Updating
information on frequency 5240 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591624] cfg80211: (5140000 KHz
- 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591630] cfg80211: Updating
information on frequency 5260 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591636] cfg80211: (5140000 KHz
- 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591641] cfg80211: Updating
information on frequency 5280 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591648] cfg80211: (5140000 KHz
- 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591654] cfg80211: Updating
information on frequency 5300 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591661] cfg80211: (5140000 KHz
- 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591668] cfg80211: Updating
information on frequency 5320 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591675] cfg80211: (5140000 KHz
- 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591680] cfg80211: Disabling
freq 5500 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591685] cfg80211: Disabling
freq 5520 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591691] cfg80211: Disabling
freq 5540 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591697] cfg80211: Disabling
freq 5560 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591703] cfg80211: Disabling
freq 5580 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591708] cfg80211: Disabling
freq 5600 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591714] cfg80211: Disabling
freq 5620 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591719] cfg80211: Disabling
freq 5640 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591725] cfg80211: Disabling
freq 5660 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591731] cfg80211: Disabling
freq 5680 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591737] cfg80211: Disabling
freq 5700 MHz as custom regd has no rule that fits it
Nov 21 07:53:23 MrProper kernel: [    9.591743] cfg80211: Updating
information on frequency 5720 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591750] cfg80211: (5715000 KHz
- 5860000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591755] cfg80211: Updating
information on frequency 5745 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591762] cfg80211: (5715000 KHz
- 5860000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591768] cfg80211: Updating
information on frequency 5765 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591775] cfg80211: (5715000 KHz
- 5860000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591782] cfg80211: Updating
information on frequency 5785 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591788] cfg80211: (5715000 KHz
- 5860000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591795] cfg80211: Updating
information on frequency 5805 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591802] cfg80211: (5715000 KHz
- 5860000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591808] cfg80211: Updating
information on frequency 5825 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591815] cfg80211: (5715000 KHz
- 5860000 KHz @ 80000 KHz), (N/A, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591975] cfg80211: Updating
information on frequency 5180 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.591987] cfg80211: (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.591996] cfg80211: Updating
information on frequency 5200 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592003] cfg80211: (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592010] cfg80211: Updating
information on frequency 5220 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592017] cfg80211: (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592024] cfg80211: Updating
information on frequency 5240 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592030] cfg80211: (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592037] cfg80211: Updating
information on frequency 5260 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592043] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592050] cfg80211: Updating
information on frequency 5280 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592056] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592062] cfg80211: Updating
information on frequency 5300 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592069] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592075] cfg80211: Updating
information on frequency 5320 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592081] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592088] cfg80211: Updating
information on frequency 5500 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592094] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592100] cfg80211: Updating
information on frequency 5520 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592107] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592113] cfg80211: Updating
information on frequency 5540 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592119] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592125] cfg80211: Updating
information on frequency 5560 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592131] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592137] cfg80211: Updating
information on frequency 5580 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592143] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592150] cfg80211: Disabling
freq 5600 MHz
Nov 21 07:53:23 MrProper kernel: [    9.592154] cfg80211: Disabling
freq 5620 MHz
Nov 21 07:53:23 MrProper kernel: [    9.592159] cfg80211: Disabling
freq 5640 MHz
Nov 21 07:53:23 MrProper kernel: [    9.592165] cfg80211: Updating
information on frequency 5660 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592171] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592177] cfg80211: Updating
information on frequency 5680 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592184] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592190] cfg80211: Updating
information on frequency 5700 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592197] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592202] cfg80211: Disabling
freq 5720 MHz
Nov 21 07:53:23 MrProper kernel: [    9.592208] cfg80211: Updating
information on frequency 5745 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592214] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592220] cfg80211: Updating
information on frequency 5765 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592226] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592233] cfg80211: Updating
information on frequency 5785 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592239] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592245] cfg80211: Updating
information on frequency 5805 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592251] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.592257] cfg80211: Updating
information on frequency 5825 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.592263] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593783] cfg80211: Updating
information on frequency 5180 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593797] cfg80211: (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593805] cfg80211: Updating
information on frequency 5200 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593812] cfg80211: (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593819] cfg80211: Updating
information on frequency 5220 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593825] cfg80211: (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593832] cfg80211: Updating
information on frequency 5240 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593838] cfg80211: (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593845] cfg80211: Updating
information on frequency 5260 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593851] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593857] cfg80211: Updating
information on frequency 5280 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593863] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593870] cfg80211: Updating
information on frequency 5300 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593876] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593882] cfg80211: Updating
information on frequency 5320 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593888] cfg80211: (5250000 KHz
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593894] cfg80211: Updating
information on frequency 5500 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593900] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593906] cfg80211: Updating
information on frequency 5520 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593913] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593919] cfg80211: Updating
information on frequency 5540 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593925] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593931] cfg80211: Updating
information on frequency 5560 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593937] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593943] cfg80211: Updating
information on frequency 5580 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593950] cfg80211: (5490000 KHz
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593956] cfg80211: Disabling
freq 5600 MHz for good
Nov 21 07:53:23 MrProper kernel: [    9.593961] cfg80211: Disabling
freq 5620 MHz for good
Nov 21 07:53:23 MrProper kernel: [    9.593966] cfg80211: Disabling
freq 5640 MHz for good
Nov 21 07:53:23 MrProper kernel: [    9.593972] cfg80211: Updating
information on frequency 5660 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593978] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593984] cfg80211: Updating
information on frequency 5680 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.593990] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.593997] cfg80211: Updating
information on frequency 5700 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.594004] cfg80211: (5650000 KHz
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.594009] cfg80211: Disabling
freq 5720 MHz for good
Nov 21 07:53:23 MrProper kernel: [    9.594015] cfg80211: Updating
information on frequency 5745 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.594021] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.594027] cfg80211: Updating
information on frequency 5765 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.594033] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.594040] cfg80211: Updating
information on frequency 5785 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.594046] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.594052] cfg80211: Updating
information on frequency 5805 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.594058] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:23 MrProper kernel: [    9.594064] cfg80211: Updating
information on frequency 5825 MHz with regulatory rule:
Nov 21 07:53:23 MrProper kernel: [    9.594070] cfg80211: (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 21 07:53:25 MrProper dhclient: DHCPDISCOVER on eth1 to
255.255.255.255 port 67 interval 5 (xid=3D0x7e93e3c2)
Nov 21 07:53:25 MrProper kernel: [   10.946730] sky2 0000:08:00.0
eth1: Link is up at 1000 Mbps, full duplex, flow control both
Nov 21 07:53:25 MrProper kernel: [   10.946777] IPv6:
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
Nov 21 07:53:30 MrProper dhclient: DHCPDISCOVER on eth1 to
255.255.255.255 port 67 interval 10 (xid=3D0x7e93e3c2)
Nov 21 07:53:31 MrProper dhclient: DHCPREQUEST of 192.168.10.141 on
eth1 to 255.255.255.255 port 67 (xid=3D0x7e93e3c2)
Nov 21 07:53:31 MrProper dhclient: DHCPOFFER of 192.168.10.141 from 192.168=
.10.1
Nov 21 07:53:31 MrProper dhclient: DHCPACK of 192.168.10.141 from 192.168.1=
0.1
Nov 21 07:53:31 MrProper dhclient: bound to 192.168.10.141 -- renewal
in 39009 seconds.
Nov 21 07:53:31 MrProper cron[816]: (CRON) INFO (pidfile fd =3D 3)
Nov 21 07:53:31 MrProper cron[847]: (CRON) STARTUP (fork ok)
Nov 21 07:53:31 MrProper cron[847]: (CRON) INFO (Running @reboot jobs)
Nov 21 07:53:32 MrProper dnsmasq[888]: started, version 2.68 cachesize 150
Nov 21 07:53:32 MrProper dnsmasq[888]: compile time options: IPv6
GNU-getopt DBus i18n IDN DHCP DHCPv6 no-Lua TFTP conntrack ipset auth
Nov 21 07:53:32 MrProper dnsmasq[888]: reading /var/run/dnsmasq/resolv.conf
Nov 21 07:53:32 MrProper dnsmasq[888]: using nameserver 147.83.2.10#53
Nov 21 07:53:32 MrProper dnsmasq[888]: using nameserver 147.83.2.3#53
Nov 21 07:53:32 MrProper dnsmasq[888]: read /etc/hosts - 4 addresses
Nov 21 07:53:40 MrProper ntpdate[778]: no server suitable for
synchronization found
Nov 21 07:53:46 MrProper dnsmasq[888]: reading /var/run/dnsmasq/resolv.conf
Nov 21 07:53:46 MrProper dnsmasq[888]: using nameserver 147.83.2.10#53
Nov 21 07:53:46 MrProper dnsmasq[888]: using nameserver 147.83.2.3#53
Nov 21 07:53:55 MrProper ntpdate[980]: no server suitable for
synchronization found
Nov 21 07:54:23 MrProper kernel: [   69.620067] cfg80211: Verifying
active interfaces after reg change

It seems that there are some frequency slots wth the @8000KHz
then
root@MrProper:~# iw dev wlan0 interface add mp0 type mp
root@MrProper:~# iw dev mp0 set freq 5745 80 5775
command failed: Invalid argument (-22)
root@MrProper:~# iw dev mp0 set freq 5715 80 5860
command failed: Invalid argument (-22)
root@MrProper:~# iw dev mp0 set freq 5715 80 5795
command failed: Invalid argument (-22)
root@MrProper:~# iw dev mp0 set freq 5250 80 5330
command failed: Invalid argument (-22)
root@MrProper:~# iw dev mp0 set freq 5140 80 5360
command failed: Invalid argument (-22)
root@MrProper:~# iw dev mp0 set freq 5140 80 5220
command failed: Invalid argument (-22)


So I performed
iw dev mp0 set channel 149 HT40+
ifconfig mp0 192.168.149.201

and syslog start to spam this messge:

Nov 21 08:08:44 MrProper kernel: [  930.230501] util.c |
ieee80211_set_wmm_default: ac=3D0, enable_qos=3Dtrue, vif.type=3D7,
NL80211_IFTYPE_STATION=3D2
Nov 21 08:08:44 MrProper kernel: [  930.231078] IPv6:
ADDRCONF(NETDEV_UP): mp0: link is not ready
Nov 21 08:08:44 MrProper kernel: [  930.557731] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:44 MrProper kernel: [  930.559964] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:44 MrProper kernel: [  930.570153] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:44 MrProper kernel: [  930.629822] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:44 MrProper kernel: [  930.638655] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:44 MrProper kernel: [  930.639220] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:44 MrProper kernel: [  930.646044] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:44 MrProper kernel: [  930.650553] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:45 MrProper kernel: [  930.650936] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:45 MrProper kernel: [  930.684057] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:50 MrProper kernel: [  935.858389] ath10k_warn: 12
callbacks suppressed
Nov 21 08:08:50 MrProper kernel: [  935.858441] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:50 MrProper kernel: [  936.104414] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:50 MrProper kernel: [  936.104778] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:50 MrProper kernel: [  936.195287] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:53 MrProper kernel: [  938.769794] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:53 MrProper kernel: [  939.004773] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:54 MrProper kernel: [  939.723923] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:54 MrProper kernel: [  939.981543] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:08:56 MrProper kernel: [  942.534539] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:09:01 MrProper kernel: [  947.401511] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:09:05 MrProper kernel: [  951.507954] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:09:05 MrProper kernel: [  951.514654] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:09:07 MrProper kernel: [  952.837610] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:09:24 MrProper kernel: [  970.049900] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:09:24 MrProper kernel: [  970.050242] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:09:41 MrProper kernel: [  987.160219] util.c |
ieee80211_set_wmm_default: ac=3D0, enable_qos=3Dtrue, vif.type=3D7,
NL80211_IFTYPE_STATION=3D2
Nov 21 08:09:41 MrProper kernel: [  987.161400] IPv6:
ADDRCONF(NETDEV_UP): mp0: link is not ready
Nov 21 08:09:42 MrProper kernel: [  988.010692] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 08:09:42 MrProper kernel: [  988.488288] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
...

I had this issue in the past but only in some cases when the module
ath10k_core was loaded without the rawmode =3D 1 parameter:
Now It's happening everytime and it stops as soon as the interface
join the mesh:
Nov 21 09:29:39 MrProper kernel: [ 1409.470318] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 09:29:40 MrProper kernel: [ 1409.875986] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 09:29:40 MrProper kernel: [ 1410.496021] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 09:29:40 MrProper kernel: [ 1410.509777] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 09:29:40 MrProper kernel: [ 1410.571394] ath10k_pci
0000:07:00.0: no channel configured; ignoring frame(s)!
Nov 21 09:29:43 MrProper kernel: [ 1412.762457] mp0: setting non-peer
PM to user value
Nov 21 09:29:43 MrProper kernel: [ 1412.763537] IPv6:
ADDRCONF(NETDEV_CHANGE): mp0: link becomes ready
Nov 21 09:29:43 MrProper kernel: [ 1412.941533] mp0: Allocated STA
04:f0:21:15:ac:79
Nov 21 09:29:43 MrProper kernel: [ 1412.941564] mp0: moving STA
04:f0:21:15:ac:79 to state 2
Nov 21 09:29:43 MrProper kernel: [ 1412.941581] mp0: moving STA
04:f0:21:15:ac:79 to state 3
Nov 21 09:29:43 MrProper kernel: [ 1412.941598] mp0: moving STA
04:f0:21:15:ac:79 to state 4
Nov 21 09:29:43 MrProper kernel: [ 1412.942118] mp0: Inserted STA
04:f0:21:15:ac:79
Nov 21 09:29:43 MrProper kernel: [ 1412.942174] mp0: Mesh plink:
starting establishment with 04:f0:21:15:ac:79
Nov 21 09:29:43 MrProper kernel: [ 1412.942190] mp0: setting non-peer
PM to active for peering
Nov 21 09:29:43 MrProper kernel: [ 1412.944349] mp0: peer
04:f0:21:15:ac:79 in state OPN-SNT got event OPN_ACPT
Nov 21 09:29:43 MrProper kernel: [ 1412.944653] mp0: peer
04:f0:21:15:ac:79 in state OPN-RCVD got event CNF_ACPT
Nov 21 09:29:43 MrProper kernel: [ 1412.944679] mp0: selected new HT
protection mode 0
Nov 21 09:29:43 MrProper kernel: [ 1412.944702] mp0: mesh_plink
04:f0:21:15:ac:77: ERP short slot time 1
Nov 21 09:29:43 MrProper kernel: [ 1412.944717] mp0: Mesh plink with
04:f0:21:15:ac:79 ESTABLISHED
Nov 21 09:29:43 MrProper kernel: [ 1412.944734] mp0: local STA
operates in mode 1 with 04:f0:21:15:ac:79
Nov 21 09:29:43 MrProper kernel: [ 1412.944755] mp0: announcing
peer-specific power mode to 04:f0:21:15:ac:79
Nov 21 09:29:43 MrProper kernel: [ 1412.944794] mp0: setting non-peer
PM to user value
Nov 21 09:29:43 MrProper kernel: [ 1413.117282] mp0: Allocated STA
e0:ca:94:5f:a7:d6
Nov 21 09:29:43 MrProper kernel: [ 1413.117312] mp0: moving STA
e0:ca:94:5f:a7:d6 to state 2
Nov 21 09:29:43 MrProper kernel: [ 1413.117333] mp0: moving STA
e0:ca:94:5f:a7:d6 to state 3
Nov 21 09:29:43 MrProper kernel: [ 1413.117350] mp0: moving STA
e0:ca:94:5f:a7:d6 to state 4
Nov 21 09:29:43 MrProper kernel: [ 1413.117882] mp0: Inserted STA
e0:ca:94:5f:a7:d6
Nov 21 09:29:43 MrProper kernel: [ 1413.117941] mp0: Mesh plink:
starting establishment with e0:ca:94:5f:a7:d6
Nov 21 09:29:43 MrProper kernel: [ 1413.117957] mp0: setting non-peer
PM to active for peering
Nov 21 09:29:43 MrProper kernel: [ 1413.121287] mp0: peer
e0:ca:94:5f:a7:d6 in state OPN-SNT got event OPN_ACPT
Nov 21 09:29:43 MrProper kernel: [ 1413.121387] mp0: peer
e0:ca:94:5f:a7:d6 in state OPN-RCVD got event CNF_ACPT
Nov 21 09:29:43 MrProper kernel: [ 1413.121410] mp0: nonHT sta
(e0:ca:94:5f:a7:d6) is present
Nov 21 09:29:43 MrProper kernel: [ 1413.121426] mp0: selected new HT
protection mode 3
Nov 21 09:29:43 MrProper kernel: [ 1413.121443] mp0: Mesh plink with
e0:ca:94:5f:a7:d6 ESTABLISHED
Nov 21 09:29:43 MrProper kernel: [ 1413.121461] mp0: local STA
operates in mode 1 with e0:ca:94:5f:a7:d6
Nov 21 09:29:43 MrProper kernel: [ 1413.121478] mp0: announcing
peer-specific power mode to e0:ca:94:5f:a7:d6
Nov 21 09:29:43 MrProper kernel: [ 1413.121514] mp0: setting non-peer
PM to user value
Nov 21 09:29:43 MrProper kernel: [ 1413.122713] mp0: STA
e0:ca:94:5f:a7:d6 enters mode 1


Other (hopefully) useful info:
root@MrProper:~# iw reg get
global
country US: DFS-UNSET
    (2402 - 2472 @ 40), (3, 27), (N/A)
    (5170 - 5250 @ 40), (3, 17), (N/A)
    (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
    (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
    (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
    (5735 - 5835 @ 40), (3, 30), (N/A)
    (57240 - 63720 @ 2160), (N/A, 40), (N/A)

phy#2
country US: DFS-UNSET
    (2402 - 2472 @ 40), (3, 27), (N/A)
    (5170 - 5250 @ 40), (3, 17), (N/A)
    (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
    (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
    (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
    (5735 - 5835 @ 40), (3, 30), (N/A)
    (57240 - 63720 @ 2160), (N/A, 40), (N/A)

phy#0
country US: DFS-UNSET
    (2402 - 2472 @ 40), (3, 27), (N/A)
    (5170 - 5250 @ 40), (3, 17), (N/A)
    (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
    (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
    (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
    (5735 - 5835 @ 40), (3, 30), (N/A)
    (57240 - 63720 @ 2160), (N/A, 40), (N/A)

phy#1
country US: DFS-UNSET
    (2402 - 2472 @ 40), (3, 27), (N/A)
    (5170 - 5250 @ 40), (3, 17), (N/A)
    (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
    (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
    (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
    (5735 - 5835 @ 40), (3, 30), (N/A)
    (57240 - 63720 @ 2160), (N/A, 40), (N/A)

root@MrProper:~# iw dev wlan0 info #Compex WLE600V5-27 ath10k QCA988X
Interface wlan0
    ifindex 9
    wdev 0x200000001
    addr 04:f0:21:15:ac:77
    type managed
    wiphy 2
    txpower 0.00 dBm
root@MrProper:~# iw dev mp0 info #Virtual interface acting as mesh point
Interface mp0
    ifindex 10
    wdev 0x200000002
    addr 04:f0:21:15:ac:77
    type mesh point
    wiphy 2
    txpower 0.00 dBm
root@MrProper:~# iw dev wlan3 info #Compex WLE-200NX ath9k
Interface wlan3
    ifindex 7
    wdev 0x100000001
    addr 04:f0:21:0a:6c:7c
    type managed
    wiphy 1
    txpower 0.00 dBm

root@MrProper:~# iw dev mp0 info #Virtual mp interface after join the
mesh network
Interface mp0
    ifindex 11
    wdev 0x100000002
    addr 04:f0:21:15:ac:77
    type mesh point
    wiphy 1
    channel 48 (5240 MHz), width: 40 MHz, center1: 5230 MHz
    txpower 17.00 dBm


root@MrProper:~# iw --version
iw version 4.9

Checking on Internet I didn't find a working solution, and the data
rate stucks to 120Mbps MCS7.
For me it still a mistery, I hope in your help.

All the Best

Matteo

2016-11-20 12:09 GMT+01:00 Michal Kazior <michal.kazior@tieto.com>:
> On 20 November 2016 at 02:07, Bob Copeland <me@bobcopeland.com> wrote:
>> On Fri, Nov 18, 2016 at 10:43:06PM +0100, Matteo Grandi wrote:
>>> So the question is: who decide if use MIMO and higher MCS hopefully on
>>> 80MHz channel or not? Is the firmware? Is there a way to force the
>>> interface to use 80MHz and/or MIMO? (iw provide the possibility to
>>> choose between [HT20/HT40-/HT40+]).
>>
>> You can specify the channel width like so:
>>
>> iw dev wlan0 set freq 5745 80 5775
>> iw dev wlan0 mesh join mesh-vht
>
> With recent enough `iw` you can check the operational (max) bandwidth
> of the interface with:
>
>   iw dev wlan0 info
>
> I don't know how mesh nodes negotiate their capabilities to each other
> though so I don't know how reliable this is.
>
> Actual modulation is picked by rate control in firmware. You can try
> to force a fixed rate with[1]:
>
>  iw dev wlan0 set bitrates legacy-5 ht-mcs-5 vht-mcs-5 1:9
>
> It doesn't allow setting fixed bandwidth though so you'll need to
> check rx bitrate on the receiving end to verify.
>
> [1]: https://wireless.wiki.kernel.org/en/users/drivers/ath10k/debug?s[]=
=3Dset&s[]=3Dbitrates#manual_bitrates_configuration
>
>
> Micha=C5=82
