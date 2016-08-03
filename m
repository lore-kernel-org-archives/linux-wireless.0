Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3071 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932195AbcHCOWH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 10:22:07 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: handle edmac vendor command
Date: Wed, 3 Aug 2016 11:20:57 +0000
Message-ID: <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com> (sfid-20160803_162306_193285_8D26D8DA)
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
	<cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
 <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

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
> 

Did you get a chance to check this patch?
Please let me know if you have any suggestions.

Regards,
Amitkumar
