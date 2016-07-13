Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46688 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbcGMP5s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 11:57:48 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: [PATCH v3 1/2] mwifiex: add manufacturing mode support
Date: Wed, 13 Jul 2016 15:57:15 +0000
Message-ID: <2dcba20e490840918e80c4f91a250739@SC-EXCH04.marvell.com> (sfid-20160713_175751_961112_1364A574)
References: <1468417703-32716-1-git-send-email-akarwar@marvell.com>
 <87twfta66k.fsf@purkki.adurom.net>
In-Reply-To: <87twfta66k.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, July 13, 2016 9:20 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
> Subject: Re: [PATCH v3 1/2] mwifiex: add manufacturing mode support
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > By default normal mode is chosen when driver is loaded. This patch
> > adds a provision to choose manufacturing mode via module parameters.
> >
> > Command to load driver in manufacturing mode insmod mwifiex.ko
> > mfg_mode=1 and mfg_firmware=mrvl/firmware.
> >
> > Tested-by: chunfan chen <jeffc@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> Why the mfg_firmware module parameter?

It's to specify a firmware name.

Regards,
Amitkumar Karwar
