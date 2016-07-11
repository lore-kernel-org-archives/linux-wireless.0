Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:60174 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbcGKNw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 09:52:57 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH ath9k-txq-work 1/2] ath9k: fix powersave wakeup
References: <20160711130405.77451-1-nbd@nbd.name>
Date: Mon, 11 Jul 2016 15:52:53 +0200
In-Reply-To: <20160711130405.77451-1-nbd@nbd.name> (Felix Fietkau's message of
	"Mon, 11 Jul 2016 15:04:04 +0200")
Message-ID: <871t30wabu.fsf@toke.dk> (sfid-20160711_155301_250423_951CDE81)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> drv_wake_tx_queue will only call into the driver if there are frames
> pending in the mac80211 queue. the driver needs to take care of its own
> queued frames

Thanks, makes sense. What's the proper etiquette here? Do I roll these
up into a v4 (possibly with other changes that show up along the way),
or do they go in as separate patches?

-Toke
