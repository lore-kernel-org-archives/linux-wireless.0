Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37577 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbcC3MuH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 08:50:07 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v5 2/4] mwifiex: add platform specific wakeup interrupt
 support
Date: Wed, 30 Mar 2016 12:50:03 +0000
Message-ID: <9b96089aa29a4202b2ccc8110315c174@SC-EXCH04.marvell.com> (sfid-20160330_145012_590383_9C0DA299)
References: <1458299032-31929-1-git-send-email-akarwar@marvell.com>
	<1458299032-31929-2-git-send-email-akarwar@marvell.com>
 <87a8lg5eej.fsf@purkki.adurom.net>
In-Reply-To: <87a8lg5eej.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, March 30, 2016 6:09 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> devicetree@vger.kernel.org; Wei-Ning Huang; Xinming Hu
> Subject: Re: [PATCH v5 2/4] mwifiex: add platform specific wakeup
> interrupt support
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: Xinming Hu <huxm@marvell.com>
> >
> > On some arm-based platforms, we need to configure platform specific
> > parameters by device tree node and also define our node as a child
> > node of parent SDIO host controller.
> > This patch parses these parameters from device tree. It includes
> > calibration data dowoload to firmware, wakeup pin configured to
> > firmware, and soc specific wake up gpio, which will be set as wakeup
> interrupt pin.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> I only see patch 2, where are the rest three? Also it's not clear what's
> the plan with this patchset.
> 

Yes. It should have been [PATCH v5 2/2]
I am going to submit v6 shortly which address below comments from Rob Herring.
https://patchwork.kernel.org/patch/8618261/

Regards,
Amitkumar
