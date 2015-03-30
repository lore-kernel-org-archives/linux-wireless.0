Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55317 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbbC3OAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:00:33 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 5/5] wil6210: update FW file name
Date: Mon, 30 Mar 2015 17:00:00 +0300
Message-ID: <16442708.jC9XbHNgDJ@lx-wigig-72> (sfid-20150330_160040_188469_2709C3A6)
In-Reply-To: <87wq1y6d1b.fsf@kamboji.qca.qualcomm.com>
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1427704134-30699-6-git-send-email-qca_vkondrat@qca.qualcomm.com> <87wq1y6d1b.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 30, 2015 12:38:08 PM Kalle Valo wrote:
> Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:
> 
> > Firmware "board" file name has changed from wil6210.board
> > to wil6210.brd by the FW generation tools.
> >
> > Reflect this in the driver.
> >

> > -#define WIL_FW2_NAME "wil6210.board" /* board & radio parameters */
> > +#define WIL_FW2_NAME "wil6210.brd" /* board & radio parameters */
> 
> I consider the firmware file names as part of stable user space
> interface (older user space need to work with newer kernel etc) and this
> change breaks that.
> 

Hardware was not released to the public yet; no one besides developers
in the lab should be affected by this.

Thanks, Vladimir
