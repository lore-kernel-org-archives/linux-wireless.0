Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:5418 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750935Ab1HQEyd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 00:54:33 -0400
From: Lin Tony-B19295 <B19295@freescale.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Subject: RE: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
Date: Wed, 17 Aug 2011 04:53:32 +0000
Message-ID: <97D3A72708D04647A5AC84A04996E5B5195C30@039-SN1MPN1-002.039d.mgd.msft.net> (sfid-20110817_065440_172262_4D6547CD)
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
 <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4A7159.3090004@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195ADD@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4B437A.1070200@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195BE5@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4B48E4.7060809@qca.qualcomm.com>
In-Reply-To: <4E4B48E4.7060809@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@qca.qualcomm.com]
> Sent: Wednesday, August 17, 2011 12:52 PM
> To: Lin Tony-B19295
> Cc: Hauke Mehrtens; mcgrof@gmail.com; rodrigue@qca.qualcomm.com; linux-
> wireless@vger.kernel.org; rmani@qca.qualcomm.com
> Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
> 
> On 08/16/2011 09:44 PM, Lin Tony-B19295 wrote:
> >>> Besides, the performance seems not good. I got only 5Mb/s
> >>> station->station performance. While another driver released from your
> >>> AE could reach at least 10Mb/s, do you have any idea?
> >>
> >> That sounds quite low. Can you describe your test setup in detail,
> please?
> >> That would help to understand the issue.
> >>
> > Both PC and board are connected to an AP. And set PC as host, 'iperf -
> s'
> > Set board as client, 'iperf -c pc ipaddr -t 100000 -w 1M -i 3'
> > If using another package, I get 23Mb/s
> 
> What wifi settings do you use? (11n, encryption, frequency, etc)
> 
11n, no encryption, 50Mhz.

> Does dmesg show anything suspicious?
> 
Does not see any suspicious...

> Kalle


