Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0126.outbound.protection.outlook.com ([157.55.234.126]:41649
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752015AbcF2PSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:18:54 -0400
From: "Baumann, Christoph (C.)" <cbaumann@visteon.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v8] Add new mac80211 driver mwlwifi.
Date: Wed, 29 Jun 2016 13:44:38 +0000
Message-ID: <DB5PR06MB1285C28251AB35F0F86DE178D0230@DB5PR06MB1285.eurprd06.prod.outlook.com> (sfid-20160629_171909_741955_C18C5B1F)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello David,

I tried this new driver and it worked for me (board based on Renesas R-Car H3).
But Inoticed that the data rates are asymmetrical (seen from the device):
	* iperf -c (mainly TX): 598 Kbits/sec to 2.67 Mbits/sec
	* iperf -s (mainly RX): 64.4 Mbits/sec to 69.2 Mbits/sec



Regards,
Christoph
