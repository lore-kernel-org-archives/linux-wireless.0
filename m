Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20664 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaB0QNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:13:36 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: David Herrmann <dh.herrmann@gmail.com>
CC: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Tom Gundersen <teg@jklm.no>,
	Johannes berg <johannes@sipsolutions.net>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: set NET_NAME_USER for P2P ifs
References: <1393512434-1325-1-git-send-email-dh.herrmann@gmail.com>
	<1393512434-1325-4-git-send-email-dh.herrmann@gmail.com>
	<87bnxsfuee.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 27 Feb 2014 18:13:29 +0200
In-Reply-To: <87bnxsfuee.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Thu, 27 Feb 2014 17:27:21 +0200")
Message-ID: <87txbkedp2.fsf@kamboji.qca.qualcomm.com> (sfid-20140227_171422_896631_608EA5A4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> David Herrmann <dh.herrmann@gmail.com> writes:
>
>> P2P netdevs and other devices that are created via nl80211 from user-space
>> have a name provided by user-space. Therefore, set NET_NAME_USER so this
>> is correctly shown in sysfs.
>>
>> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>
> Looks good to me.
>
> Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>
>
> Can I take this to my ath.git tree?

Nevermind, I saw the first patch now. Just CCing random patches like
this is confusing for the recipients, better to CC the full patchset.

-- 
Kalle Valo
