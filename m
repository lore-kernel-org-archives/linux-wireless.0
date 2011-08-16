Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:37939
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab1HPE7b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 00:59:31 -0400
From: Lin Tony-B19295 <B19295@freescale.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
CC: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Subject: RE: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
Date: Tue, 16 Aug 2011 04:59:29 +0000
Message-ID: <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net> (sfid-20110816_065937_408462_6CCD649A)
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
 <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com>
In-Reply-To: <4E49BAB1.7060303@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Kalle:

	Some questions regarding this ath6kl driver.
	Does it support all AR6003 card family? As I know there're several types of AR6003 cards
	Does it support master mode? I tried the driver, seems it doesn't. need your confirmation.
		root@freescale ~$ iwconfig wlan0 mode master
		Error for wireless request "Set Mode" (8B06) :
    		SET failed on device wlan0 ; Invalid argument.

	Does it support suspend/resume well? From my experiments, seems not. After resuming, connection is lost.

	Thanks
Tony

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@qca.qualcomm.com]
> Sent: Tuesday, August 16, 2011 8:33 AM
> To: Hauke Mehrtens
> Cc: Lin Tony-B19295; mcgrof@gmail.com; rodrigue@qca.qualcomm.com; linux-
> wireless@vger.kernel.org; rmani@qca.qualcomm.com
> Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
> 
> On 08/15/2011 11:59 AM, Hauke Mehrtens wrote:
> > On 08/15/2011 07:06 AM, Lin Tony-B19295 wrote:
> >> Where can I get corresponding firmware?
> >>
> >> tony
> >
> > Hi tony,
> >
> > there is a firmware for these devices in the linux-firmware git [0],
> > but I do not know if it still works with this driver.
> >
> > Probably some of the ath6kl developer could help you more than me.
> 
> Yes, the firmware in linux-firmware should work. If not, please report it
> to linux-wireless mailing list.
> 
> Kalle


