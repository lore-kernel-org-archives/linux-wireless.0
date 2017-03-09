Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35087 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750758AbdCIGgs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 01:36:48 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        "Nishant Sarmukadam" <nishants@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Subject: RE: [EXT] Re: [PATCH 1/3] mwifiex: add qualifier to firmware
 structures
Date: Thu, 9 Mar 2017 06:35:57 +0000
Message-ID: <5a45c32cb855493f9704435c10851243@SC-EXCH02.marvell.com> (sfid-20170309_073710_939033_F86DBCB8)
References: <1488980829-6075-1-git-send-email-gbhat@marvell.com>
        <1488980829-6075-2-git-send-email-gbhat@marvell.com>
 <874lz37rkv.fsf@purkki.adurom.net>
In-Reply-To: <874lz37rkv.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, March 08, 2017 8:18 PM
> To: Ganapathi Bhat
> Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo;
> Nishant Sarmukadam; Karthik Doddayennegere Ananthapadmanabha
> Subject: Re: [PATCH 1/3] mwifiex: add qualifier to firmware
> structures
>
> Ganapathi Bhat <gbhat@marvell.com> writes:
> 
> > From: Karthik D A <karthida@marvell.com>
> >
> > Adding qualifier "__packed" indicates that no padding should be
> > performed on the qualified object for alignment.
> > This patch adds qualifier __packed to the required firmware
> structures
> > in mwifiex driver.
> >
> > Signed-off-by: Karthik D A <karthida@marvell.com>
> 
> I just want to confirm "Karthik D A" is really the full legal name,
> which should be in both From and Signed-off-by lines. No nicknames nor
> just the first name or anything like that.
>
That was author's initials. I will resend the patch with complete name.
>
> 
> Also this should contain S-o-b from Ganapathi. Please carefully read
> Documentation/process/submitting-patches.rst.
> 
Sure. I will edit this too and will refer the same for further submitting.
> --

Regards,
Ganapathi
