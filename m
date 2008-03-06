Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:26967 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbYCFUUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 15:20:40 -0500
Received: by rn-out-0910.google.com with SMTP id v46so70869rnb.15
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 12:20:39 -0800 (PST)
Message-ID: <c4aed99f0803061220y40628cdxc8c2a4a0d2cac89f@mail.gmail.com> (sfid-20080306_202058_089969_94E2C325)
Date: Thu, 6 Mar 2008 15:20:38 -0500
From: "Chris Hallinan" <challinan@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwl4965 on Compaq 8510p wireless speed very low, unusable
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tried many combinations of kernel (2.6.21 to current 2.6.24.3),
several combinations of mac80211, iwlwifi and iww4965 microcode,
including latest stable (1.2.0) and dev versions.  Still can't get
past about 30KB download speeds.  Access point is Linksys Wireless-B -
other machines on same network can get 10-15 times that speed w/ a
variety of adapters.

I've enabled logging in kernel config, but logs don't reveal anything unusual:

$ dmesg | grep iwl4965
[   14.296000] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for
Linux, 1.2.25ds **
[   14.296000] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[   14.296000] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   14.700000] iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
 ** (also tried 1.1.0, 1.2.0ds)

$ iwconfig wlan0
wlan0     IEEE 802.11g  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:0C:41:66:A3:F9
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Link Quality=55/100  Signal level=-45 dBm  Noise level=-70 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

$ uname -a
Linux brutus2 2.6.22-14-generic #1 SMP Sun Oct 14 23:05:12 GMT 2007
i686 GNU/Linux
(Gutsy Gibbons stock kernel)

After a couple days of searching (Google, bughost, etc) I've noticed
others with similar problems, but never came across a resolution.  Bug
1481 is similar, though not exact.  Performance is acceptable under
WinXP (400KB+)

Is this a configuration issue or a genuine bug?  Any help would be
greatly appreciated.

I'll be happy to enter a bug report, and assist in any way I can
(testing, etc) to help reach a resolution.

-Chris Hallinan

-- 
Life is like Linux - it never stands still.
