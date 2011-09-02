Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4661 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab1IBIXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 04:23:23 -0400
Date: Fri, 2 Sep 2011 13:53:04 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3] ath6kl: ath6kl: Add debugfs interface to dump
	diagnostic registers
Message-ID: <20110902082303.GD5883@vasanth-laptop> (sfid-20110902_102329_957762_F464D961)
References: <1314871752-13740-1-git-send-email-vthiagar@qca.qualcomm.com> <4E608BD7.5060104@qca.qualcomm.com> <20110902080100.GA5883@vasanth-laptop> <4E609204.5080300@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E609204.5080300@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 02, 2011 at 11:21:24AM +0300, Kalle Valo wrote:
> On 09/02/2011 11:01 AM, Vasanthakumar Thiagarajan wrote:
> > On Fri, Sep 02, 2011 at 10:55:03AM +0300, Kalle Valo wrote:
> >> On 09/01/2011 01:09 PM, Vasanthakumar Thiagarajan wrote:
> >>
> >> Thanks, applied. But I did minor changes:
> >>
> >> commit 91d57de5adfc40184ef7cb8974104459c5211add
> >> Author: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> >> Date:   Fri Sep 2 10:40:06 2011 +0300
> >>
> >>     ath6kl: Add debugfs interface to dump diagnostic registers from firmware
> >>
> >>     To dump a particular register:
> >>
> >>         echo <reg_addr> > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr
> >>
> >>     To dump the entire register set:
> >>
> >>         echo 0 > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr
> >>
> >>     Register values will be available at:
> >>
> >>         cat <debugfs_root>/ieee80211/phyX/ath6kl/reg_dump
> >>
> >>     kvalo: commit log cleanup, renamed few functions, removed a warning
> >>     message
> > 
> > Thanks, what is the warning?
> 
> I just removed the ath6kl_warn() about invalid register address in
> ath6kl_dbg_is_diag_reg_valid(). Kernel should not send any debug logs in
> that case.

Ok, thanks.
> 
> > Did you apply my other patch which fixes endianess?.
> 
> No, not yet. I still have patches pending for review. Will finish them
> today.

No problem, i thought it was a sparse warning.

Vasanth
