Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22251 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbbBONkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 08:40:23 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: ath10k <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: station kickout
References: <54D29F71.50603@candelatech.com>
Date: Sun, 15 Feb 2015 15:40:16 +0200
In-Reply-To: <54D29F71.50603@candelatech.com> (Ben Greear's message of "Wed,
	04 Feb 2015 14:38:41 -0800")
Message-ID: <87d25bi98f.fsf@kamboji.qca.qualcomm.com> (sfid-20150215_144027_441021_D104BD92)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding linux-wireless)

Ben Greear <greearb@candelatech.com> writes:

> In AP mode, it seems that 3.17-ish kernels (at least) always set station kickout
> to hard-coded value of 50.
>
> Is this something that should be configurable?  Maybe a module parameter
> if nothing else?

Or should we add this to nl80211/cfg80211/mac80211? I would guess other
drivers also have similar functionality.

-- 
Kalle Valo
