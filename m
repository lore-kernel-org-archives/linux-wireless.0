Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41787 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab2AEHai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 02:30:38 -0500
Received: by obcwo16 with SMTP id wo16so236461obc.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2012 23:30:37 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Jan 2012 15:30:36 +0800
Message-ID: <CAHzJmyaXGpZO3TFaMwqKZaYwO4brtxWENoekvGSdo20UVdUVZg@mail.gmail.com> (sfid-20120105_083042_277862_293CD895)
Subject: ath9k_htc.ko
From: Linx Zhang <linx.zhang@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

Anyone knows how to setup Atheros USB wifi card(TP-LINK WN821N) as AP
mode on the linux (Ubuntu 11.10)? I have tested below commands, but
failed:

mypromp#iwconfig
wlan0     IEEE 802.11bgn  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

mypromp#/wlanconfig ath create wlandev wlan0 wlanmode ap
wlanconfig: ioctl: Operation not supported

mypromp# lsmod
Module                  Size  Used by
ath9k_htc              51280  0
ath9k_common            1661  1 ath9k_htc
ath9k_hw              335589  2 ath9k_htc,ath9k_common
ath                    13592  3 ath9k_htc,ath9k_common,ath9k_hw
mac80211              224045  1 ath9k_htc
cfg80211              151788  3 ath9k_htc,ath,mac80211
compat                 15880  3 ath9k_htc,mac80211,cfg80211
rfkill                 14626  1 cfg80211

mypromp# lsusb
Bus 001 Device 007: ID 0cf3:7015 Atheros Communications, Inc.

Any comments or helps will be appreciated!

Thanks.

Morris
