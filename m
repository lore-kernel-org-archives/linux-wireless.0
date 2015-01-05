Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60333 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbbAEKRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 05:17:46 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-01-05
References: <1420449079.12040.3.camel@egrumbacBox>
Date: Mon, 05 Jan 2015 12:17:39 +0200
In-Reply-To: <1420449079.12040.3.camel@egrumbacBox> (Emmanuel Grumbach's
	message of "Mon, 5 Jan 2015 09:11:18 +0000")
Message-ID: <87ppat3518.fsf@kamboji.qca.qualcomm.com> (sfid-20150105_111751_447157_AB24538A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> This is new content for 3.19. Details in the tag. Let me know if you have issues.
> Thanks!

Thanks, pulled.

One comment:

> ----------------------------------------------------------------
> * fix for 7265D NVM check
> * fixes for scan: fix long scanning times and network
> 	discovery
> * new firmware API for iwlmvm supported devices
> * fixes in rate control
>
> ----------------------------------------------------------------
> Arik Nemtsov (1):
>       iwlwifi: pcie: correctly define 7265-D cfg
>
> David Spinadel (2):
>       iwlwifi: mvm: add a flag to enable match found notification
>       iwlwifi: mvm: scan dwell time corrections
>
> Emmanuel Grumbach (2):
>       iwlwifi: 7000: fix reported firmware name for 7265D
>       iwlwifi: bump firmware API for mvm devices to 12

To me the firmware API bump is in a gray area, I don't see how it really
fixes anything. I would feel much more comfortable if the patch would
document why the bump is needed in -rc series and why it couldn't wait
for -next. I'm guessing it has somethign to do with the dwell time
corrections, but it's not obvious to me (and others).

-- 
Kalle Valo
