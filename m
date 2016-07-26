Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43012 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbcGZNAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2016 09:00:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 wl-drv-next 0/2] register-field manipulation macros
References: <1467821977-11777-1-git-send-email-jakub.kicinski@netronome.com>
	<20160725154549.6492cac1@jkicinski-Precision-T1700>
Date: Tue, 26 Jul 2016 16:00:04 +0300
In-Reply-To: <20160725154549.6492cac1@jkicinski-Precision-T1700> (Jakub
	Kicinski's message of "Mon, 25 Jul 2016 15:45:49 +0100")
Message-ID: <87y44od06j.fsf@kamboji.qca.qualcomm.com> (sfid-20160726_150014_224100_183CDD31)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> On Wed,  6 Jul 2016 17:19:35 +0100, Jakub Kicinski wrote:
>> Hi!
>> 
>> I've added few lines about the compilation problems in 
>> the commit message of patch 1.  I would prefer the mass
>> rename of macros in mt7601u not to be part of this series
>> so patch 2 is left as it was and I'll follow up once this
>> is accepted.
>
> Hi Kalle,
>
> what's the status of this set?  It's marked as 'Deferred' in
> linux-wireless patchwork.

Like I said before, I would prefer to see an ack from someone else like
Andrew Morton or Dave Miller. I don't feel comfortable adding new files
to include/ without some sort of support from others. Or maybe Andrew
could even take these directly to his tree?

-- 
Kalle Valo
