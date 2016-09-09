Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59214 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755029AbcIIMrE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:47:04 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: mwifiex: PCIe8997 chip specific handling
Date: Fri, 9 Sep 2016 12:46:53 +0000
Message-ID: <97cd910e00754cad8441eda273962f97@SC-EXCH04.marvell.com> (sfid-20160909_144837_287843_07625283)
References: <1469788731-5361-1-git-send-email-akarwar@marvell.com>
        <20160909091449.A66606183E@smtp.codeaurora.org>
        <5c381ec576c54a7fad54e7a23a060e29@SC-EXCH04.marvell.com>
 <87a8fhqpn8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a8fhqpn8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Friday, September 09, 2016 4:58 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
> Subject: Re: mwifiex: PCIe8997 chip specific handling
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > Hi Kalle,
> >
> >> -----Original Message-----
> >> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> >> owner@vger.kernel.org] On Behalf Of Kalle Valo
> >> Sent: Friday, September 09, 2016 2:45 PM
> >> To: Amitkumar Karwar
> >> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> >> Amitkumar Karwar
> >> Subject: Re: mwifiex: PCIe8997 chip specific handling
> >>
> >> Amitkumar Karwar <akarwar@marvell.com> wrote:
> >> > The patch corrects the revision id register and uses it along with
> >> > magic value and chip version registers to download appropriate
> >> > firmware image.
> >> >
> >> > PCIe8997 Z chipset variant code has been removed, as it won't be
> >> > used in production.
> >> >
> >> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> >>
> >> Does apply, please rebase:
> >>
> >> Applying: mwifiex: PCIe8997 chip specific handling
> >> fatal: sha1 information is lacking or useless
> >> (drivers/net/wireless/marvell/mwifiex/pcie.c).
> >> Repository lacks necessary blobs to fall back on 3-way merge.
> >> Cannot fall back to three-way merge.
> >> Patch failed at 0001 mwifiex: PCIe8997 chip specific handling
> >>
> >
> > The patch now smoothly applies to top of the tree. It had a dependency
> > with "mwifiex: add PCIe function level reset support" which is merged.
> > Let me know if there is still a problem.
> 
> Ok, I applied it now. But if there's a dependency to another patch
> please document it after the "---" line, a lot easier that way.
> 

Thanks. Sure. I will use "---" and take care of this for future patches.

Regards,
Amitkumar
