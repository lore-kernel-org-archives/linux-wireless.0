Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44740 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab1IBIVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 04:21:47 -0400
Date: Fri, 2 Sep 2011 13:51:28 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3] ath6kl: ath6kl: Add debugfs interface to dump
	diagnostic registers
Message-ID: <20110902082127.GC5883@vasanth-laptop> (sfid-20110902_102156_682759_D4664826)
References: <1314871752-13740-1-git-send-email-vthiagar@qca.qualcomm.com> <4E608BD7.5060104@qca.qualcomm.com> <20110902080100.GA5883@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110902080100.GA5883@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 02, 2011 at 01:31:01PM +0530, Vasanthakumar Thiagarajan wrote:
> On Fri, Sep 02, 2011 at 10:55:03AM +0300, Kalle Valo wrote:
> > On 09/01/2011 01:09 PM, Vasanthakumar Thiagarajan wrote:
> > > To dump a particular register, echo reg_addr > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr,
> > > to dump the entire register set, echo 0 > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr, and
> > > register values will be available at <debugfs_root>/ieee80211/phyX/ath6kl/reg_dump.
> > 
> > Thanks, applied. But I did minor changes:
> > 
> > commit 91d57de5adfc40184ef7cb8974104459c5211add
> > Author: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> > Date:   Fri Sep 2 10:40:06 2011 +0300
> > 
> >     ath6kl: Add debugfs interface to dump diagnostic registers from firmware
> > 
> >     To dump a particular register:
> > 
> >         echo <reg_addr> > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr
> > 
> >     To dump the entire register set:
> > 
> >         echo 0 > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr
> > 
> >     Register values will be available at:
> > 
> >         cat <debugfs_root>/ieee80211/phyX/ath6kl/reg_dump
> > 
> >     kvalo: commit log cleanup, renamed few functions, removed a warning
> >     message
> 
> Thanks, what is the warning?. Did you apply my other patch which
> fixes endianess?.

I mean the following patch, I can resend it again, if you want.
[PATCH 2/2] ath6kl: Fix endianness in requesting chip register read

Vasanth
