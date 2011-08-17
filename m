Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:21108 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1HQEoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 00:44:16 -0400
From: Lin Tony-B19295 <B19295@freescale.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Subject: RE: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
Date: Wed, 17 Aug 2011 04:44:09 +0000
Message-ID: <97D3A72708D04647A5AC84A04996E5B5195BE5@039-SN1MPN1-002.039d.mgd.msft.net> (sfid-20110817_064425_170024_7FB85957)
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
 <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4A7159.3090004@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195ADD@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4B437A.1070200@qca.qualcomm.com>
In-Reply-To: <4E4B437A.1070200@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@qca.qualcomm.com]
> Sent: Wednesday, August 17, 2011 12:29 PM
> To: Lin Tony-B19295
> Cc: Hauke Mehrtens; mcgrof@gmail.com; rodrigue@qca.qualcomm.com; linux-
> wireless@vger.kernel.org; rmani@qca.qualcomm.com
> Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
> 
> On 08/16/2011 07:19 PM, Lin Tony-B19295 wrote:
> >> I have a patch pending to add suspend support and will send it as
> >> soon as I find some free time. But the wifi connection will be lost
> >> in resume anyway. If you want to maintain the connection to AP during
> >> suspend then you are looking for wowlan support which ath6kl doesn't
> >> currently support.
> >
> > Do you have any plan supporting it?
> 
> It would be nice to have support for wowlan but I don't know when it will
> be implemented. Hopefully sooner than later.
> 
> > Besides, the performance seems not good. I got only 5Mb/s
> > station->station performance. While another driver released from your
> > AE could reach at least 10Mb/s, do you have any idea?
> 
> That sounds quite low. Can you describe your test setup in detail, please?
> That would help to understand the issue.
> 
Both PC and board are connected to an AP. And set PC as host, 'iperf -s'
Set board as client, 'iperf -c pc ipaddr -t 100000 -w 1M -i 3'
If using another package, I get 23Mb/s

> Kalle


