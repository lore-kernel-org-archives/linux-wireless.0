Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57800 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751042AbeA2HRQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 02:17:16 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Subject: RE: [EXT] Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX
 stall
Date: Mon, 29 Jan 2018 07:17:12 +0000
Message-ID: <c30565031fa54173b92bac878475171a@SC-EXCH02.marvell.com> (sfid-20180129_081720_506330_66B9D854)
References: <1516633497-6584-3-git-send-email-gbhat@marvell.com>
 <20180125071202.0F39560A60@smtp.codeaurora.org>
 <e7a1f375b450451da611477943d2eeb6@SC-EXCH02.marvell.com>
 <20180125183355.rpmajajr5exxcybb@ban.mtv.corp.google.com>
In-Reply-To: <20180125183355.rpmajajr5exxcybb@ban.mtv.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> -----Original Message-----
> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Friday, January 26, 2018 12:04 AM
> To: Ganapathi Bhat
> Cc: Kalle Valo; linux-wireless@vger.kernel.org; Cathy Luo; Xinming Hu;
> Zhiyuan Yang; James Cao; Mangesh Malusare; Shrenik Shikhare
> Subject: Re: [EXT] Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX
> stall
>
> On Thu, Jan 25, 2018 at 09:59:04AM +0000, Ganapathi Bhat wrote:
> > > I can't find any commit with id c7dbdcb2a4e1, is it correct?
> > Correct. Actually the commit id c7dbdcb2a4e1 is the PATCH [1/2] sent in this
> series.
>
> What? Why would you introduce a bug and only fix it in the next patch?
With the first patch the original issue took considerably longer time to recreate. Also it followed a different path to get recreated(shared in commit message).
> Does that mean you should just combine the two?
Let us know if that is fine to merge them. We can modify the commit message accordingly.
> Or reverse the order, if patch 2 doesn't cause problems on its own?
Patch 2 has a dependency on patch 1.
>
> Brian

Regards,
Ganapathi
