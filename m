Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15453 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbcAEKgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:36:33 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"Jeff CF Chen" <jeffc@marvell.com>
Subject: RE: [PATCH 1/3] mwifiex: fix misleading firmware download messages
Date: Tue, 5 Jan 2016 10:36:28 +0000
Message-ID: <b5822a02cb5a4566b685dddb44fe92db@SC-EXCH04.marvell.com> (sfid-20160105_113636_609153_083EC151)
References: <1451486589-15010-1-git-send-email-akarwar@marvell.com>
 <8760z8mj4o.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8760z8mj4o.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Tuesday, January 05, 2016 3:41 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam; Jeff
> CF Chen
> Subject: Re: [PATCH 1/3] mwifiex: fix misleading firmware download
> messages
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: chunfan chen <jeffc@marvell.com>
> >
> > mwifiex_check_fw_status() checks firmware status and also check if
> > WLAN is the winner for firmware downloading.
> >
> > Once we detect that other interface is downloading the firmware, we
> > call this routine again with max poll count to wait until firmware is
> > ready.
> >
> > This patch splits the routine to avoid checking winner status multiple
> > times and ensures that correct warning messages are displayed.
> >
> > Firmware status poll count is also increased to 150.
> 
> The title is somewhat misleading, you are doing a lot more than just
> fixing messages. Also please clarify the concept here, especially about
> "winner", "loser" and the other interface.
> 

Thanks for review. I will submit updated version with below changes.
1) Change title to "mwifiex: firmware download enhancements"
2) Modified description to explain "winner", "loser" and the other interface concepts.

> > Signed-off-by: chunfan chen <jeffc@marvell.com>
> 
> It's good practise to capitalise the name.
> 

Ack.

Regards,
Amitkumar Karwar
