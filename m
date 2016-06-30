Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20301 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbcF3BP1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 21:15:27 -0400
From: David Lin <dlin@marvell.com>
To: "Baumann, Christoph (C.)" <cbaumann@visteon.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Chor Teck Law <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: RE: [PATCH v8] Add new mac80211 driver mwlwifi.
Date: Thu, 30 Jun 2016 01:15:25 +0000
Message-ID: <ce48c516ec364bcaba5bb938165e0927@SC-EXCH02.marvell.com> (sfid-20160630_031531_142486_A455BE7F)
References: <DB5PR06MB1285C28251AB35F0F86DE178D0230@DB5PR06MB1285.eurprd06.prod.outlook.com>
In-Reply-To: <DB5PR06MB1285C28251AB35F0F86DE178D0230@DB5PR06MB1285.eurprd06.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: linux-wireless-owner@vger.kernel.org
> [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Baumann,
> Christoph (C.)
> Sent: Wednesday, June 29, 2016 9:45 PM
> To: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v8] Add new mac80211 driver mwlwifi.
> 
> Hello David,
> 
> I tried this new driver and it worked for me (board based on Renesas R-Car
> H3).
> But Inoticed that the data rates are asymmetrical (seen from the device):
> 	* iperf -c (mainly TX): 598 Kbits/sec to 2.67 Mbits/sec
> 	* iperf -s (mainly RX): 64.4 Mbits/sec to 69.2 Mbits/sec
>

Please check https://github.com/kaloz/mwlwifi to get latest firmware and configuration sample.

If you still get problem, please open an issue on https://github.com/kaloz/mwlwifi.

You can get HW, driver and firmware information via "cat /sys/kernel/debug/ieee80211/phy0/mwlwifi/info".

Please specify your configuration and test environment.

Thanks,
David

> 
> 
> Regards,
> Christoph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
