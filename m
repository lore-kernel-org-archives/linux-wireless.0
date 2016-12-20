Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.icm.edu.pl ([213.135.59.49]:52629 "EHLO mx1.icm.edu.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932609AbcLTQaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 11:30:14 -0500
Date: Tue, 20 Dec 2016 17:24:29 +0100
From: =?ISO-8859-2?Q?=A3ukasz?= Walewski <ljw@icm.edu.pl>
To: linux-wireless@vger.kernel.org
Cc: ilw@linux.intel.com, sgruszka@redhat.com
Subject: iwl3945 randomly crashes
Message-Id: <20161220172429.300dc743cad7b840857142a1@icm.edu.pl> (sfid-20161220_173017_908503_8A9534DE)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using the latest Lubuntu 16.10 with fairly recent kernel

ljw@hideo:~$ uname -a
Linux hideo 4.8.0-30-generic #32-Ubuntu SMP Fri Dec 2 03:43:33 UTC 2016 i686 i686 i686 GNU/Linux

on an old Toshiba laptop (Satellite Pro U200) equipped with an Intel PRO/Wireless 3945ABG adapter

ljw@hideo:~$ lspci | grep ireless
02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)

The wireless network crashes once in a while with no apparent reason with the following log entries:

Dec 18 17:23:42 hideo kernel: [94900.863133] iwl3945 0000:02:00.0: loaded firmware version 15.32.2.9
Dec 18 17:23:42 hideo kernel: [94900.913626] iwl3945 0000:02:00.0: BSM uCode verification failed at addr 0x00003800+0 (of 900), is 0xa5a5a5a2, s/b 0xf802020
Dec 18 17:23:42 hideo kernel: [94900.913633] iwl3945 0000:02:00.0: Unable to set up bootstrap uCode: -5

This problem has been reported several times on different mailing lists and community portals all over the Internet, nevertheless I was not able to locate the right fix for it.

The workaround suggested elswhere (restarting the network-manager when the problem occurs) works with my setup.

Could you please suggest the solution to the problem? Alternatively, where should I file the bug to get it fixed?

Thank you very much in advance,
Lukasz Walewski

-- 
£ukasz Walewski <ljw@icm.edu.pl>
