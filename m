Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:42985 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZIXBAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 21:00:39 -0400
Received: by bwz6 with SMTP id 6so974467bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 18:00:42 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 18:00:41 -0700
Message-ID: <da94abde0909231800v75b05677ka6b8570a73b6055c@mail.gmail.com>
Subject: wireless-testing broken
From: Kalle Valo <kalle.valo@iki.fi>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I upgraded to latest wireless-testing and noticed that I can't connect
anymore with my iwl3945. master-2009-09-16 still works. My syslog has
this:

Sep 24 03:53:28 tikku kernel: [  719.479190] phy0: device no longer
idle - scanning
Sep 24 03:53:31 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
Sep 24 03:53:31 tikku wpa_supplicant[12381]: Trying to associate with
00:03:52:d9:27:10 (SSID='ibahn' freq=2452 MHz)
Sep 24 03:53:31 tikku wpa_supplicant[12381]: Association request to
the driver failed
Sep 24 03:53:31 tikku kernel: [  722.096782] phy0: device now idle
Sep 24 03:53:31 tikku kernel: [  722.099163] phy0: device no longer
idle - scanning
Sep 24 03:53:31 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
Sep 24 03:53:31 tikku kernel: [  722.101652] phy0: device now idle
Sep 24 03:53:32 tikku kernel: [  723.101920] phy0: device no longer
idle - scanning
Sep 24 03:53:34 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
Sep 24 03:53:34 tikku kernel: [  725.804837] phy0: device now idle
Sep 24 03:53:36 tikku wpa_supplicant[12381]: Authentication with
00:03:52:d9:27:10 timed out.
Sep 24 03:53:36 tikku kernel: [  727.101285] phy0: device no longer
idle - scanning
Sep 24 03:53:38 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
Sep 24 03:53:38 tikku wpa_supplicant[12381]: Trying to associate with
00:03:52:d9:77:70 (SSID='ibahn' freq=2427 MHz)
Sep 24 03:53:38 tikku wpa_supplicant[12381]: Association request to
the driver failed
Sep 24 03:53:38 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
Sep 24 03:53:38 tikku kernel: [  729.816160] phy0: device now idle
Sep 24 03:53:39 tikku kernel: [  730.777467] phy0: device no longer
idle - scanning
Sep 24 03:53:42 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
Sep 24 03:53:42 tikku kernel: [  733.389081] phy0: device now idle
Sep 24 03:53:43 tikku wpa_supplicant[12381]: Authentication with
00:03:52:d9:77:70 timed out.
Sep 24 03:53:43 tikku kernel: [  734.737634] phy0: device no longer
idle - scanning
Sep 24 03:53:46 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
Sep 24 03:53:46 tikku wpa_supplicant[12381]: Trying to associate with
00:03:52:a4:7d:b0 (SSID='ibahn' freq=2432 MHz)
Sep 24 03:53:46 tikku wpa_supplicant[12381]: Association request to
the driver failed
Sep 24 03:53:46 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
Sep 24 03:53:46 tikku kernel: [  737.428317] phy0: device now idle
Sep 24 03:53:47 tikku kernel: [  738.414783] phy0: device no longer
idle - scanning
Sep 24 03:53:50 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS

But gotta run now, more info later.

Kalle
