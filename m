Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59387 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbcGMQkX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 12:40:23 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: [PATCH v3 1/2] mwifiex: add manufacturing mode support
Date: Wed, 13 Jul 2016 16:39:42 +0000
Message-ID: <219643fbabd740c3a8a79b8a3e99d5ad@SC-EXCH04.marvell.com> (sfid-20160713_184137_250411_801BF12E)
References: <1468417703-32716-1-git-send-email-akarwar@marvell.com>
	<87twfta66k.fsf@purkki.adurom.net>
	<2dcba20e490840918e80c4f91a250739@SC-EXCH04.marvell.com>
 <87eg6xzeih.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87eg6xzeih.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, July 13, 2016 10:01 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
> Subject: Re: [PATCH v3 1/2] mwifiex: add manufacturing mode support
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > Hi Kalle,
> >
> >> -----Original Message-----
> >> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> >> Sent: Wednesday, July 13, 2016 9:20 PM
> >> To: Amitkumar Karwar
> >> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
> >> Subject: Re: [PATCH v3 1/2] mwifiex: add manufacturing mode support
> >>
> >> Amitkumar Karwar <akarwar@marvell.com> writes:
> >>
> >> > By default normal mode is chosen when driver is loaded. This patch
> >> > adds a provision to choose manufacturing mode via module
> parameters.
> >> >
> >> > Command to load driver in manufacturing mode insmod mwifiex.ko
> >> > mfg_mode=1 and mfg_firmware=mrvl/firmware.
> >> >
> >> > Tested-by: chunfan chen <jeffc@marvell.com>
> >> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> >>
> >> Why the mfg_firmware module parameter?
> >
> > It's to specify a firmware name.
> 
> Yeah, I got that. But why do you need that? Why not just hardcode the
> firmware name in the driver, which is the normal thing to do?

Ok. I will do this in updated version.

Regards,
Amitkumar
