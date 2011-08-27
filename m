Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18880 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1H0LQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 07:16:14 -0400
Date: Sat, 27 Aug 2011 16:46:42 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Add debugfs support for mac/baseband samples
Message-ID: <20110827111641.GA17693@vmraj-lnx.users.atheros.com> (sfid-20110827_131621_980112_69863ECD)
References: <1314442067-11799-1-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-Vmo=wLETTSy0i3uz3Zj5w+_o+AouzD=nJzFk9KnERK+g7Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJ-Vmo=wLETTSy0i3uz3Zj5w+_o+AouzD=nJzFk9KnERK+g7Cg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 27, 2011 at 06:52:50PM +0800, Adrian Chadd wrote:
> On 27 August 2011 18:47, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> > This patch keep track of number of samples that includes
> > DMA debugs registers, PCU observe, CR, channel noise,
> > cycle conters, noisefloor history buffer and last N number
> > of tx and rx descriptor status. These samples are grouped
> 
> Is this written in a way that makes it easy to conditionally compile
> them in/out?
>
Yes ofcourse.

--
Rajkumar
