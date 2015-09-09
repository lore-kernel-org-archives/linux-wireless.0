Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:46089 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbIISXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 14:23:33 -0400
Received: from smtp07.msg.oleane.net (smtp07.mail.priv [172.17.20.116])
	by smtp-out05.msg.oleane.net with ESMTP id t89HYtOw008098
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2015 19:34:55 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp07.msg.oleane.net (MTA) with ESMTP id t89HEWXP014670
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2015 19:14:33 +0200
Subject: Ath10K issue
Date: Wed, 9 Sep 2015 19:13:59 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Message-ID: <773DB8A82AB6A046AE0195C68612A31901BBD213@sbs2003.acksys.local> (sfid-20150909_202337_142926_B500E7CA)
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	I'm using compat-wireless 2015-03-09 from openwrt.

	At the power up, these equipments worked in AP mode and several sta can do an association.
	Randomly it is not possible to make association to several AP.

	If I look the log file I see cyclically these error messages.
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.116104] ath10k_warn: 186 callbacks suppressed
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.133185] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 3, skipped old beacon
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.153058] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.157255] ath10k_pci 0001:02:00.0: reached WMI management transmit queue limit
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.157260] ath10k_pci 0001:02:00.0: failed to transmit packet, dropping: -16
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.212297] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 2, skipped old beacon
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.232087] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 3, skipped old beacon
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.252874] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.286774] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 2, skipped old beacon
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.320914] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 3, skipped old beacon
Wed Sep  9 10:29:49 2015 kern.warn kernel: [17654.355043] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.167694] ath10k_warn: 193 callbacks suppressed
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.184778] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.204514] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 2, skipped old beacon
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.225098] ath10k_pci 0001:02:00.0: reached WMI management transmit queue limit
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.235968] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 3, skipped old beacon
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.264524] ath10k_pci 0001:02:00.0: failed to transmit packet, dropping: -16
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.270094] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 0, skipped old beacon
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.303945] ath10k_pci 0001:02:00.0: failed to transmit management frame via WMI: -11
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.304408] ath10k_pci 0001:02:00.0: reached WMI management transmit queue limit
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.304414] ath10k_pci 0001:02:00.0: failed to transmit packet, dropping: -16
Wed Sep  9 10:29:54 2015 kern.warn kernel: [17659.363876] ath10k_pci 0001:02:00.0: SWBA overrun on vdev 2, skipped old beacon
Wed Sep  9 10:29:59 2015 kern.warn kernel: [17664.219316] ath10k_warn: 208 callbacks suppressed

	To reestablish my access point I need to restart the Wifi (wifi up in openwrt).

	Have you any idea of this issue?

	Regards.

Cédric Voncken.
