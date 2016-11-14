Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40477 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932305AbcKNMp5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 07:45:57 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH v2 3/3] mwifiex: Enable WoWLAN for both sdio and pcie
Date: Mon, 14 Nov 2016 12:45:54 +0000
Message-ID: <5d7a50a21e384d098651d8e4b73a8934@SC-EXCH04.marvell.com> (sfid-20161114_134618_851534_5D8E0FF0)
References: <1478862911-15498-1-git-send-email-akarwar@marvell.com>
 <1478862911-15498-3-git-send-email-akarwar@marvell.com>
 <20161111204235.GB111624@google.com>
In-Reply-To: <20161111204235.GB111624@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Saturday, November 12, 2016 2:13 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; dmitry.torokhov@gmail.com
> Subject: Re: [PATCH v2 3/3] mwifiex: Enable WoWLAN for both sdio and
> pcie
> 
> On Fri, Nov 11, 2016 at 04:45:11PM +0530, Amitkumar Karwar wrote:
> > From: Rajat Jain <rajatja@google.com>
> >
> > Commit ce4f6f0c353b ("mwifiex: add platform specific wakeup interrupt
> > support") added WoWLAN feature only for sdio. This patch moves that
> > code to the common module so that all the interface drivers can use
> it
> > for free. It enables pcie and sdio for its use currently.
> >
> > Signed-off-by: Rajat Jain <rajatja@google.com>
> > ---
> > v2: v1 doesn't apply smoothly on latest code due to recently merged
> > patch "mwifiex: report error to PCIe for suspend failure". Minor
> > conflict is resolved in v2
> > ---
> 
> In case you haven't noticed my comments elsewhere, I'll repeat them
> here: you're copy-and-pasting buggy code. That can be OK I suppose, but
> please fix these issues, possibly in a follow-up patch.

Thanks for pointing this. I will post separate follow-up patch which address this issue as per your suggestion.

Regards,
Amitkumar
