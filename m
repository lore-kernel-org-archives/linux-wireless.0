Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41326 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756430Ab2B2VgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 16:36:16 -0500
Received: by lahj13 with SMTP id j13so4069706lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 13:36:14 -0800 (PST)
Message-ID: <4F4E9A36.2080809@lacto.se> (sfid-20120229_223620_468102_ECC752CC)
Date: Wed, 29 Feb 2012 22:35:50 +0100
From: =?ISO-8859-1?Q?Kim_Lidstr=F6m?= <dexter@lacto.se>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: "Failed to stop Tx DMA" and "Could not stop RX" with AR9485
Content-Type: multipart/mixed;
 boundary="------------050205080306030501030504"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050205080306030501030504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello!
A while ago I had a situation where my AR9485 would lock up the kernel
so bad and two very nice guys(Mohammed Shafi and Adrian.. Uhm.. Sorry I
forgot his last name) were very patient in helping me and trying to
debug it through patches, etc. Nothing worked.
Eventually, though, I noticed that when I removed the atl1c module my
wlan started working. "Awesome!" I thought... Until I noticed this other
problem.

Once in a while, seemingly at random, the wlan dies with the error
messages in the title. And I can't possibly restore it without
restarting the computer.

With this message I have attached a log with the error messages.
This has been a problem since.. Uhm.. Kernel 3.2.something and I'm
currently running 3.2.8.
For some reason it happened at least 3-4 times shortly after each other
today - so I thought I might ask on here what's happening.

--------------050205080306030501030504
Content-Type: text/plain;
 name="dmesg-ath.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-ath.txt"

[   13.010134] ath9k 0000:07:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   13.010160] ath9k 0000:07:00.0: setting latency timer to 64
[   13.018216] ath: EEPROM regdomain: 0x65
[   13.018222] ath: EEPROM indicates we should expect a direct regpair map
[   13.018229] ath: Country alpha2 being used: 00
[   13.018233] ath: Regpair used: 0x65
[   13.045598] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[   13.046709] Registered led device: ath9k-phy0
[  125.432441] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006100
[  125.438365] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2778.307941] ath: Failed to stop TX DMA, queues=0x001!
[ 2778.316757] ath: Failed to stop TX DMA, queues=0x001!
[ 2778.328959] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2778.329001] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2778.956071] ath: Failed to stop TX DMA, queues=0x001!
[ 2778.964851] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.065389] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.077624] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2779.077666] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.148709] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.160946] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2779.160987] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.232040] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.244279] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026e00
[ 2779.244320] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.315390] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.327625] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026e00
[ 2779.327667] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.398714] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.410946] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024800
[ 2779.410988] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.482047] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.494280] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2779.494321] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.565391] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.635381] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.647613] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2779.647655] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.718719] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.730960] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2779.731001] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.802055] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.814292] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2779.814333] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2779.885382] ath: Failed to stop TX DMA, queues=0x001!
[ 2779.897612] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2779.897653] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2780.035637] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2780.035683] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.218730] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.230968] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2786.231010] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.302047] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.314279] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2786.314320] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.385371] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.397611] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026e00
[ 2786.397653] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.468725] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.480970] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2786.481012] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.552061] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.564291] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2786.564332] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.635371] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.647612] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2786.647653] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.718722] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.730957] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2786.730999] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.802041] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.814278] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2786.814318] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.885379] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.897612] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2786.897653] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2786.968722] ath: Failed to stop TX DMA, queues=0x001!
[ 2786.980957] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026700
[ 2786.980999] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2787.052048] ath: Failed to stop TX DMA, queues=0x001!
[ 2787.064278] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2787.064319] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2787.202303] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024800
[ 2787.202349] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.115624] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2791.115670] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.188715] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.200969] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2791.201011] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.272056] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.284290] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026700
[ 2791.284333] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.355372] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.367612] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2791.367653] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.438706] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.450945] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2791.450986] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.522052] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.534291] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2791.534332] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.605374] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.617612] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2791.617654] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.688707] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.700945] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2791.700987] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.772067] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.842039] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.854278] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024800
[ 2791.854320] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2791.925381] ath: Failed to stop TX DMA, queues=0x001!
[ 2791.937611] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2791.937653] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2792.008721] ath: Failed to stop TX DMA, queues=0x001!
[ 2792.020957] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2792.020998] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2792.282302] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024800
[ 2792.282349] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.172143] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.184375] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024400
[ 2796.184416] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.255389] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.267687] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2796.267732] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.338734] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.350970] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026e00
[ 2796.351011] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.422048] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.434277] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024e00
[ 2796.434318] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.505388] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.517622] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024800
[ 2796.517664] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.588726] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.600956] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2796.600998] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.672046] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.742046] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.754277] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2796.754318] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.825378] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.837611] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2796.837653] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.908705] ath: Failed to stop TX DMA, queues=0x001!
[ 2796.920944] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026700
[ 2796.920985] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2796.992068] ath: Failed to stop TX DMA, queues=0x001!
[ 2797.004302] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026400
[ 2797.004343] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2797.265647] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024800
[ 2797.265694] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.172046] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.184278] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2801.184320] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.255390] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.267622] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2801.267663] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.338730] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.350968] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2801.351009] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.422037] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.492055] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.504289] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026800
[ 2801.504331] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.575373] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.587611] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024700
[ 2801.587652] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.658713] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.670945] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2801.670985] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.742053] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.754290] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00026700
[ 2801.754332] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.825379] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.837611] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2801.837652] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2801.908711] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.978716] ath: Failed to stop TX DMA, queues=0x001!
[ 2801.990956] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2801.990997] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2802.128955] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00006400
[ 2802.129003] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2802.268957] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x00024800
[ 2802.269004] ath: Could not stop RX, we could be confusing the DMA engine when we start RX up

--------------050205080306030501030504--
