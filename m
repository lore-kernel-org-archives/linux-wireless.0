Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31262 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbbA0Fpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 00:45:54 -0500
Message-ID: <1422357337.20608.1.camel@pe-lt950> (sfid-20150127_064557_093261_710C5D7E)
Subject: Re: [1/8] mwifiex: remove redundant nick_name variable
From: Avinash Patil <patila@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	"Marc Yang" <yangyang@marvell.com>
Date: Tue, 27 Jan 2015 16:45:37 +0530
In-Reply-To: <87lhktl843.fsf@kamboji.qca.qualcomm.com>
References: <20150123172247.812AD141654@smtp.codeaurora.org>
	 <87lhktl843.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-23 at 09:28 -0800, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> >> This is not used anywhere execpt initialization.
> >> 
> >> Signed-off-by: Avinash Patil <patila@marvell.com>
> >> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> >> Signed-off-by: Cathy Luo <cluo@marvell.com>
> >
> > Thanks, 6 patches applied to wireless-drivers-next.git:
> >
> > 5e7f03b102eb mwifiex: remove redundant nick_name variable
> > 534cfed66caf mwifiex: set wiphy params only once
> > bb2703cffb2f mwifiex: do not declare wdev as pointer
> > 7d2d4fbf4e8e mwifiex: add init parameter to init command routine
> > 16b21941fa9a mwifiex: handle PS events on AP interface as well
> > 770c385d2744 mwifiex: support conversion to any virtual interface type
> >
> > 2 patches failed to apply:
> >
> > Applying: mwifiex: store permanant mac address in adapter structure
> > error: patch failed: drivers/net/wireless/mwifiex/init.c:285
> > error: drivers/net/wireless/mwifiex/init.c: patch does not apply
> > Patch failed at 0001 mwifiex: store permanant mac address in adapter structure
> >
> > Applying: mwifiex: manage virtual interface limits efficiently
> > error: patch failed: drivers/net/wireless/mwifiex/init.c:286
> > error: drivers/net/wireless/mwifiex/init.c: patch does not apply
> > Patch failed at 0001 mwifiex: manage virtual interface limits efficiently
> 
> But mwifiex doesn't compile any more so I had to drop all patches.
> Please resend the whole series.
> 

Hi Kalle,

I will rebase patches on top of master and resend.

Thanks,
Avinash



