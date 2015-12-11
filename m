Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38737 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbbLKJdc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 04:33:32 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"Jeff CF Chen" <jeffc@marvell.com>
Subject: RE: [PATCH 5/6] mwifiex: add iw vendor command support
Date: Fri, 11 Dec 2015 09:33:28 +0000
Message-ID: <03861842539949b98d3a70ab792e4d0d@SC-EXCH04.marvell.com> (sfid-20151211_103339_161958_DBD088F4)
References: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
	<1449238387-27396-5-git-send-email-akarwar@marvell.com>
 <87eget5peq.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87eget5peq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Friday, December 11, 2015 2:32 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam; Jeff
> CF Chen
> Subject: Re: [PATCH 5/6] mwifiex: add iw vendor command support
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: chunfan chen <jeffc@marvell.com>
> >
> > The patch allows user to
> > 1. Enable turbo mode in firmware using following command.
> > iw dev mlan0 vendor send 0x005043 0x00 0x01
> >
> > 2. Download configuration data to FW using following command iw dev
> > mlan0 vendor send 0x005043 0x01 filename
> >
> > Signed-off-by: chunfan chen <jeffc@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> Stuff like this gives me nightmares and I'm going to put this patch to
> deferred state for now as I don't want to even think what to do. In the
> mean time people can convince me should I take this or not.
> 

Actually we intend to download following types of configuration data in hex format to firmware.
1)  Txpower limit table - It includes information about maximum allowed transmit power limits for all data rates and channels combination.
2)  Device calibration data

I support "iw vendor" gives an option to download hex data. 

Could you please guide how can we improve this patch? OR Any other better approach to meet the requirement?

Regards,
Amitkumar

