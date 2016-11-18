Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41947 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751243AbcKRLe2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 06:34:28 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [v7] mwifiex: parse device tree node for PCIe
Date: Fri, 18 Nov 2016 11:34:22 +0000
Message-ID: <4d83382c9a534e50b50d8a7dbff3ec1d@SC-EXCH04.marvell.com> (sfid-20161118_123432_399676_413FD0E5)
References: <1479215662-631-1-git-send-email-akarwar@marvell.com>
        <20161117123920.E159F6162A@smtp.codeaurora.org>
        <20161117173824.GA129893@google.com>
 <87y40hkpvo.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y40hkpvo.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Friday, November 18, 2016 4:38 PM
> To: Brian Norris
> Cc: Amitkumar Karwar; linux-wireless@vger.kernel.org; Cathy Luo;
> Nishant Sarmukadam; rajatja@google.com; dmitry.torokhov@gmail.com;
> Xinming Hu
> Subject: Re: [v7] mwifiex: parse device tree node for PCIe
> 
> Brian Norris <briannorris@chromium.org> writes:
> 
> > On Thu, Nov 17, 2016 at 12:39:20PM +0000, Kalle Valo wrote:
> >> Amitkumar Karwar <akarwar@marvell.com> wrote:
> >> > From: Xinming Hu <huxm@marvell.com>
> >> >
> >> > This patch derives device tree node from pcie bus layer framework.
> >> > Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> >> > marvell-8xxx.txt) to accommodate PCIe changes.
> >> >
> >> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> >> > Signed-off-by: Rajat Jain <rajatja@google.com>
> >> > Reviewed-by: Brian Norris <briannorris@chromium.org>
> >> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> >>
> >> You should CC the device tree list when making changes to the
> bindings.
> >
> > FWIW, Rajat had that right on v6...
> 
> Indeed. But please submit now v8 and also CC devicetree list. I need an
> ack from them before I can apply this.
> 

I will send v8 CCing devicetree list

Regards,
Amitkumar
