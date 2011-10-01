Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6770 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab1JAKtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 06:49:11 -0400
Date: Sat, 1 Oct 2011 16:18:18 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Enable force foreground scan in connected state
Message-ID: <20111001104816.GA18008@vasanth-laptop> (sfid-20111001_124915_168802_C6632B08)
References: <1317461107-5611-1-git-send-email-vthiagar@qca.qualcomm.com> <4E86DCC2.4020008@qca.qualcomm.com> <4E86E253.7000203@qca.qualcomm.com> <20111001104218.GA17694@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20111001104218.GA17694@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 01, 2011 at 04:12:19PM +0530, Vasanthakumar Thiagarajan wrote:
> On Sat, Oct 01, 2011 at 12:50:11PM +0300, Kalle Valo wrote:
> > On 10/01/2011 12:26 PM, Kalle Valo wrote:
> > > On 10/01/2011 12:25 PM, Vasanthakumar Thiagarajan wrote:
> > >> This was disabled beacause there was a network stall
> > >> issue when scan is issued. This issue does not happen
> > >> with the new firmware, enable it back.
> > > 
> > > Please mention the firmware version which has the fix in the commit log.
> > 
> > And I can't apply this before the new firmware available, preferably
> > even commited to linux-firmware repo.
> 
> Sure, i'm fine with that.

Actually, the new firmware is sent upstream and merged into
linux-firmware repo just now.

Vasanth
