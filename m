Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:45116
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983Ab1HQCTm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 22:19:42 -0400
From: Lin Tony-B19295 <B19295@freescale.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Subject: RE: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
Date: Wed, 17 Aug 2011 02:19:37 +0000
Message-ID: <97D3A72708D04647A5AC84A04996E5B5195ADD@039-SN1MPN1-002.039d.mgd.msft.net> (sfid-20110817_041945_554264_E1D25A47)
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
 <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com>
 <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net>
 <4E4A7159.3090004@qca.qualcomm.com>
In-Reply-To: <4E4A7159.3090004@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle:

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Kalle Valo
> Sent: Tuesday, August 16, 2011 9:32 PM
> To: Lin Tony-B19295
> Cc: Hauke Mehrtens; mcgrof@gmail.com; rodrigue@qca.qualcomm.com; linux-
> wireless@vger.kernel.org; rmani@qca.qualcomm.com
> Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
> 
> Hi Tony,
> 
> On 08/15/2011 09:59 PM, Lin Tony-B19295 wrote:
> >
> > 	Some questions regarding this ath6kl driver.
> > 	Does it support all AR6003 card family? As I know there're several
> > types of AR6003 cards
> 
> hw2.1.1 is supported and I'm using that for testing. The driver also
> supports hw2.0 but I haven't tested that so there might be some issues.
> hw1.0 is not supported.
> 
> > 	Does it support master mode?
> 
> Not yet, but hopefully in the near future.
> 
> > I tried the driver, seems it doesn't. need your confirmation.
> > 		root@freescale ~$ iwconfig wlan0 mode master
> > 		Error for wireless request "Set Mode" (8B06) :
> >     		SET failed on device wlan0 ; Invalid argument.
> 
> Like Julian said, you need to use hostapd.
> 
> > 	Does it support suspend/resume well? From my experiments, seems not.
> After resuming, connection is lost.
> 
> I have a patch pending to add suspend support and will send it as soon as
> I find some free time. But the wifi connection will be lost in resume
> anyway. If you want to maintain the connection to AP during suspend then
> you are looking for wowlan support which ath6kl doesn't currently support.
> 

Do you have any plan supporting it?
Thanks for your help
Besides, the performance seems not good. I got only 5Mb/s station->station performance. While another driver released from your AE could reach at least 10Mb/s, do you have any idea?

> Kalle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html


