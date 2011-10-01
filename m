Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19526 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1JAKqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 06:46:23 -0400
Date: Sat, 1 Oct 2011 16:12:19 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Enable force foreground scan in connected state
Message-ID: <20111001104218.GA17694@vasanth-laptop> (sfid-20111001_124627_555181_5009F610)
References: <1317461107-5611-1-git-send-email-vthiagar@qca.qualcomm.com> <4E86DCC2.4020008@qca.qualcomm.com> <4E86E253.7000203@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E86E253.7000203@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 01, 2011 at 12:50:11PM +0300, Kalle Valo wrote:
> On 10/01/2011 12:26 PM, Kalle Valo wrote:
> > On 10/01/2011 12:25 PM, Vasanthakumar Thiagarajan wrote:
> >> This was disabled beacause there was a network stall
> >> issue when scan is issued. This issue does not happen
> >> with the new firmware, enable it back.
> > 
> > Please mention the firmware version which has the fix in the commit log.
> 
> And I can't apply this before the new firmware available, preferably
> even commited to linux-firmware repo.

Sure, i'm fine with that.

Vasanth
