Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38212 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452AbbBKR5d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2015 12:57:33 -0500
From: Avinash Patil <patila@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Shengzhen Li <szli@marvell.com>
Date: Wed, 11 Feb 2015 09:57:31 -0800
Subject: RE: [PATCH 1/5] mwifiex: more_task flag for main_process
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66743F9F37@SC-VEXCH2.marvell.com> (sfid-20150211_185736_482364_C5B78E41)
References: <1423240906-12951-1-git-send-email-patila@marvell.com>
	<CBACCFA0AEB13A41977475BCF3E896FC6674321B02@SC-VEXCH2.marvell.com>
 <87wq3pn94m.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87wq3pn94m.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Tuesday, February 10, 2015 7:48 PM
> To: Avinash Patil
> Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; Marc Yang;
> Shengzhen Li
> Subject: Re: [PATCH 1/5] mwifiex: more_task flag for main_process
> 
> Avinash Patil <patila@marvell.com> writes:
> 
> > Please drop this series as we are seeing issue with DMA alignment patch.
> > I will resend v2 after fixing this.
> 
> Ok, dropped.
>
> --
> Kalle Valo
Hi Kalle,

I have sent v2 by omitting DMA alignment patch. I will send this patch separately after fixing issue.
-Avinash.
