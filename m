Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52112 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbbEKMZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 08:25:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Liu CF/TW <cfliu.tw@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param for raw tx injection, sw crypto support.
References: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com>
	<873837qo6l.fsf@kamboji.qca.qualcomm.com>
	<554CE438.5000208@candelatech.com>
Date: Mon, 11 May 2015 15:24:52 +0300
In-Reply-To: <554CE438.5000208@candelatech.com> (Ben Greear's message of "Fri,
	8 May 2015 09:28:40 -0700")
Message-ID: <87wq0fi9nv.fsf@kamboji.qca.qualcomm.com> (sfid-20150511_142510_658632_02FD8F44)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> Maybe we could have a way to specify both rx and rx mode independently of
> each other to support that use case as well?
>
> Maybe:
>
> txmode=x;  // 0 == native, 1 == raw (and maybe support other tx modes in the future as desired)
> rxmode=x;  // 0 == native, 1 == raw
> nohwcrypt=x; // 0 == standard hw crypt, 0x1 == rx-sw-crypt, 0x2 == tx-sw-crypt, 0x3 == tx/rx-sw-crypt

This looks overly complicated and hard to maintain for a very special
use case, not really excited about this.

-- 
Kalle Valo
