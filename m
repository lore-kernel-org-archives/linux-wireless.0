Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1707 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbcEXHSo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 03:18:44 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: handle edmac vendor command
Date: Tue, 24 May 2016 07:18:40 +0000
Message-ID: <5ecc9a50f78647e48e6f081bc9ce9ec8@SC-EXCH04.marvell.com> (sfid-20160524_091848_739410_A201DF14)
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
	<cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
 <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Tuesday, May 24, 2016 1:53 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] mwifiex: handle edmac vendor command
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > Hi Kalle,
> >
> >> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
> >> Sent: Friday, April 29, 2016 9:28 PM
> >> To: linux-wireless@vger.kernel.org
> >> Cc: Jeff CF Chen; Amitkumar Karwar
> >> Subject: [PATCH] mwifiex: handle edmac vendor command
> >>
> >> From: chunfan chen <jeffc@marvell.com>
> >>
> >> Userspace can configure edmac values through a custom vendor command.
> >> They will be used by hardware for adaptivity.
> >>
> >> Signed-off-by: chunfan chen <jeffc@marvell.com>
> >> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> [deleted over 200 lines of unnecessary quotes]
> 
> > This patch seems to have deferred. We basically want a way to download
> > a vendor specific configuration to our firmware. Do you have any
> > suggestions on how can achieve this in better way?
> >
> > I can see below iw command suits our requirement.
> >
> > iw dev <devname> vendor send <oui> <subcmd> <filename|-|hex data>
> >
> > Please guide.
> 
> It was deferred because use of the nl80211 vendor interface (which I
> don't think belong to upstream drivers). I'll take a look at this patch
> in detail after the merge window.

Ok. Thanks for your reply.
We will work to improve the patch if you have any suggestions.

Regards,
Amitkumar
