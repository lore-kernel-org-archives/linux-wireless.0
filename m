Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64190 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503AbbFBNrA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 09:47:00 -0400
From: Avinash Patil <patila@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, "Xinming Hu" <huxm@marvell.com>
Subject: RE: [PATCHv4 00/17] mwifiex patches
Date: Tue, 2 Jun 2015 13:46:57 +0000
Message-ID: <8f0789f2623849d69925dc93f088e7bb@SC-EXCH02.marvell.com> (sfid-20150602_154705_852408_B6EFBE73)
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
 <874mmqut3i.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <874mmqut3i.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Tuesday, June 02, 2015 7:10 PM
> To: Avinash Patil
> Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; Xinming Hu
> Subject: Re: [PATCHv4 00/17] mwifiex patches
> 
> Avinash Patil <patila@marvell.com> writes:
> 
> > This patch series mainly adds enhancements for mwifiex AP.
> > With this series, we support verbose information in station dump
> > command also information about AP link.
> > Another important enhancement is related to parsing IEs from tail of
> beacondata.
> > Few issues seen during DFS testing are also fixed in this series.
> 
> When you send a new version of a patch or patchset, please add a changelog so
> that people don't have to guess what has changed since previous version. For
> example, this cover letter is a good place to add it. You can find lots of
> examples from the mailing list archives.

Thanks, Kalle.

I will soon send v5 with change logs as suggested by you.
 
> --
> Kalle Valo
