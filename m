Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f193.google.com ([209.85.212.193]:44939 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3DAEgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 00:36:08 -0400
Received: by mail-wi0-f193.google.com with SMTP id hi18so586194wib.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 Mar 2013 21:36:07 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Apr 2013 10:06:07 +0530
Message-ID: <CAHiw28xMUXVK4S3kC+8OpnA7xVrLXEd+h+0CRs9-NYqTzZ0Z5g@mail.gmail.com> (sfid-20130401_063614_713056_CCE4466F)
Subject: Any suggestion related to not working AR6004 using SDIO interface.
From: Manohar Narkhede <mn.test3@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am connecting AR6004 development board to Ubuntu Laptop running
Linux kernel 3.5.0-19-generic #30-Ubuntu SMP Tue Nov 13 17:49:53 UTC
2012 i686 i686 i686 GNU/Linux.  I have downloaded
compat-drivers-3.8-1-u.tar and compiled it.



When the board is connected to Ubuntu Laptop, the board is getting
detected as WiFi module but not with proper settings as per below:



wlan3     IEEE 802.11abg  ESSID:off/any

          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm

          Retry  long limit:7   RTS thr:off   Fragment thr:off

          Encryption key:off

          Power Management:on





The console log for Ubuntu Laptop is:





[197015.680429] ath6kl: req failed (status:-123, ep:1, len:26 creds:1)

[197015.700184] ath6kl: Failed to release sdio irq: -123

[197015.700269] ath6kl: ath6kl_sdio_diag_write32: failed to write
0x100 to window data addr

[197015.700276] ath6kl: failed to write 0x4000 during diagnose window to 0x256

[197015.700281] ath6kl: failed to reset target

[197015.712392] mmc0: card 0001 removed

[197015.713458] sdhci-pci 0000:02:06.2: Will use DMA mode even though
HW doesn't fully claim to support it.

[197015.777140] sdhci-pci 0000:02:06.2: Will use DMA mode even though
HW doesn't fully claim to support it.

[197015.847053] sdhci-pci 0000:02:06.2: Will use DMA mode even though
HW doesn't fully claim to support it.

[197015.912068] sdhci-pci 0000:02:06.2: Will use DMA mode even though
HW doesn't fully claim to support it.

[197015.981133] sdhci-pci 0000:02:06.2: Will use DMA mode even though
HW doesn't fully claim to support it.

[197017.291946] mmc0: queuing unknown CIS tuple 0x01 (3 bytes)

[197017.304123] mmc0: queuing unknown CIS tuple 0x1a (5 bytes)

[197017.309360] mmc0: queuing unknown CIS tuple 0x1b (8 bytes)

[197017.310405] mmc0: queuing unknown CIS tuple 0x14 (0 bytes)

[197017.313732] mmc0: queuing unknown CIS tuple 0x80 (1 bytes)

[197017.313919] mmc0: queuing unknown CIS tuple 0x81 (1 bytes)

[197017.314092] mmc0: queuing unknown CIS tuple 0x82 (1 bytes)

[197017.314159] mmc0: new SDIO card at address 0001

[197017.865158] ath6kl: host only supports scatter of :1 entries, need: 16

[197017.866633] ath6kl: ar6004 hw 1.3 sdio fw 3.5.0.2356\x01 api 3

[197017.867648] cfg80211: Updating information on frequency 2412 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867656] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867697] cfg80211: Updating information on frequency 2417 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867703] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867709] cfg80211: Updating information on frequency 2422 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867715] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867720] cfg80211: Updating information on frequency 2427 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867726] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867731] cfg80211: Updating information on frequency 2432 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867737] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867743] cfg80211: Updating information on frequency 2437 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867749] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867754] cfg80211: Updating information on frequency 2442 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867760] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867765] cfg80211: Updating information on frequency 2447 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867771] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867776] cfg80211: Updating information on frequency 2452 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867782] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867787] cfg80211: Updating information on frequency 2457 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867793] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867799] cfg80211: Updating information on frequency 2462 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867805] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867810] cfg80211: Updating information on frequency 2467 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867816] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)

[197017.867821] cfg80211: Updating information on frequency 2472 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867827] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)

[197017.867833] cfg80211: Updating information on frequency 2484 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867839] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)

[197017.867844] cfg80211: Disabling freq 5170 MHz

[197017.867849] cfg80211: Updating information on frequency 5180 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867855] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867861] cfg80211: Updating information on frequency 5190 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867867] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867873] cfg80211: Updating information on frequency 5200 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867879] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867884] cfg80211: Updating information on frequency 5210 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867890] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867895] cfg80211: Updating information on frequency 5220 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867901] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867907] cfg80211: Updating information on frequency 5230 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867912] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867918] cfg80211: Updating information on frequency 5240 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867923] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.867928] cfg80211: Disabling freq 5260 MHz

[197017.867932] cfg80211: Disabling freq 5280 MHz

[197017.867936] cfg80211: Disabling freq 5300 MHz

[197017.867940] cfg80211: Disabling freq 5320 MHz

[197017.867945] cfg80211: Disabling freq 5500 MHz

[197017.867949] cfg80211: Disabling freq 5520 MHz

[197017.867953] cfg80211: Disabling freq 5540 MHz

[197017.867957] cfg80211: Disabling freq 5560 MHz

[197017.867961] cfg80211: Disabling freq 5580 MHz

[197017.867965] cfg80211: Disabling freq 5600 MHz

[197017.867969] cfg80211: Disabling freq 5620 MHz

[197017.867973] cfg80211: Disabling freq 5640 MHz

[197017.867977] cfg80211: Disabling freq 5660 MHz

[197017.867981] cfg80211: Disabling freq 5680 MHz

[197017.867985] cfg80211: Disabling freq 5700 MHz

[197017.867990] cfg80211: Updating information on frequency 5745 MHz
for a 20 MHz width channel with regulatory rule:

[197017.867996] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.868033] cfg80211: Updating information on frequency 5765 MHz
for a 20 MHz width channel with regulatory rule:

[197017.868039] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.868051] cfg80211: Updating information on frequency 5785 MHz
for a 20 MHz width channel with regulatory rule:

[197017.868068] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.868083] cfg80211: Updating information on frequency 5805 MHz
for a 20 MHz width channel with regulatory rule:

[197017.868098] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.868113] cfg80211: Updating information on frequency 5825 MHz
for a 20 MHz width channel with regulatory rule:

[197017.868130] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)

[197017.868142] cfg80211: Disabling freq 5920 MHz

[197017.868157] cfg80211: Disabling freq 5940 MHz

[197017.868171] cfg80211: Disabling freq 5960 MHz

[197017.868175] cfg80211: Disabling freq 5980 MHz

[197017.868179] cfg80211: Disabling freq 6000 MHz

[197017.868183] cfg80211: Disabling freq 6020 MHz

[197017.868187] cfg80211: Disabling freq 6040 MHz

[197017.868191] cfg80211: Disabling freq 6060 MHz

[197017.868195] cfg80211: Disabling freq 6080 MHz

[197017.900246] IPv6: ADDRCONF(NETDEV_UP): wlan3: link is not ready

[197017.901544] IPv6: ADDRCONF(NETDEV_UP): wlan3: link is not ready




Thanks,
Manohar.
