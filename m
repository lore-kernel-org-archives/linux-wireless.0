Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:52669
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab1HQFBd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 01:01:33 -0400
From: Lin Tony-B19295 <B19295@freescale.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Subject: RE: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
Date: Wed, 17 Aug 2011 05:01:28 +0000
Message-ID: <97D3A72708D04647A5AC84A04996E5B5195C5A@039-SN1MPN1-002.039d.mgd.msft.net> (sfid-20110817_070137_086193_EB9F7F4C)
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
 <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4A7159.3090004@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195ADD@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4B437A.1070200@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195BE5@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4B48E4 <4E4B4A37.3020300@qca.qualcomm.com>
In-Reply-To: <4E4B4A37.3020300@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@qca.qualcomm.com]
> Sent: Wednesday, August 17, 2011 12:57 PM
> To: Lin Tony-B19295
> Cc: Hauke Mehrtens; mcgrof@gmail.com; rodrigue@qca.qualcomm.com; linux-
> wireless@vger.kernel.org; rmani@qca.qualcomm.com
> Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
> 
> On 08/16/2011 09:53 PM, Lin Tony-B19295 wrote:
> >>> Set board as client, 'iperf -c pc ipaddr -t 100000 -w 1M -i 3'
> >>> If using another package, I get 23Mb/s
> >>
> >> What wifi settings do you use? (11n, encryption, frequency, etc)
> >>
> > 11n, no encryption, 50Mhz.
> 
> 50 MHz can't be right. Please send me output from 'iw wlan0 link' (or
> whatever interface you use with ath6kl.
> 

50MHz is SDIO interface bus clock, isn't it right?

> Kalle


