Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52622 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751034AbdJLF1t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 01:27:49 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Subject: RE: [EXT] Re: [PATCH] mwifiex: Random MAC address during scanning
Date: Thu, 12 Oct 2017 05:27:44 +0000
Message-ID: <90f90bcb559345e7bad7ba8d371a615e@SC-EXCH02.marvell.com> (sfid-20171012_072753_854687_8A21341D)
References: <1506682390-27716-1-git-send-email-gbhat@marvell.com>
 <20171011194148.GA84547@google.com>
In-Reply-To: <20171011194148.GA84547@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> ----------------------------------------------------------------------
> On Fri, Sep 29, 2017 at 04:23:10PM +0530, Ganapathi Bhat wrote:
> > From: Karthik Ananthapadmanabha <karthida@marvell.com>
> >
> > Driver will advertise RANDOM_MAC support only if the device supports
> > this feature.
> >
> > Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>
> I'd just like to point out that this is a very bad commit subject:
>
> "[PATCH] mwifiex: Random MAC address during scanning"
>
> It's borderline wrong, really. "Random MAC address during scanning" is
> already supported. This patch is just adding a feature-flag check for it, since
> some firmwares in the wild don't support it. A more accurate description
> would be something like:
>
> "[PATCH] mwifiex: Add feature flag support for MAC randomization"
>
> The patch is already applied, so I'd only worry about it for future submissions
> (no need to resend).

I'm Really Sorry.  I will take care of this in future.

>
> Brian
