Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59352 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758844AbcHaLN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 07:13:59 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: handle edmac vendor command
Date: Wed, 31 Aug 2016 11:13:54 +0000
Message-ID: <f79cfce7f84c4e1884dcc1fb571a31bd@SC-EXCH04.marvell.com> (sfid-20160831_131408_620630_CE7C7C9B)
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
        <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
 <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
 <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
In-Reply-To: <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Amitkumar Karwar
> Sent: Wednesday, August 03, 2016 4:51 PM
> To: Kalle Valo
> Cc: linux-wireless@vger.kernel.org
> Subject: RE: [PATCH] mwifiex: handle edmac vendor command
> 
> Hi Kalle,
> 
> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
> > Sent: Tuesday, May 24, 2016 1:53 AM
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org
> > Subject: Re: [PATCH] mwifiex: handle edmac vendor command
> >
> > Amitkumar Karwar <akarwar@marvell.com> writes:
> >
> > > Hi Kalle,
> > >
> > >> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
> > >> Sent: Friday, April 29, 2016 9:28 PM
> > >> To: linux-wireless@vger.kernel.org
> > >> Cc: Jeff CF Chen; Amitkumar Karwar
> > >> Subject: [PATCH] mwifiex: handle edmac vendor command
> > >>
> > >> From: chunfan chen <jeffc@marvell.com>
> > >>
> > >> Userspace can configure edmac values through a custom vendor
> command.
> > >> They will be used by hardware for adaptivity.
> > >>
> > >> Signed-off-by: chunfan chen <jeffc@marvell.com>
> > >> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> >
> > [deleted over 200 lines of unnecessary quotes]
> >
> > > This patch seems to have deferred. We basically want a way to
> > > download a vendor specific configuration to our firmware. Do you
> > > have any suggestions on how can achieve this in better way?
> > >
> > > I can see below iw command suits our requirement.
> > >
> > > iw dev <devname> vendor send <oui> <subcmd> <filename|-|hex data>
> > >
> > > Please guide.
> >
> > It was deferred because use of the nl80211 vendor interface (which I
> > don't think belong to upstream drivers). I'll take a look at this
> > patch in detail after the merge window.
> >
> 
> Did you get a chance to check this patch?
> Please let me know if you have any suggestions.
> 

Any suggestions for a mechanism to download vendor specific command to firmware?

Regards,
Amitkumar Karwar
