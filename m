Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32085 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbbALLwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:52:01 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix DMA burst size
References: <1419834066-11802-1-git-send-email-sujith@msujith.org>
	<CA+BoTQ=Vt8BTzZcgxqq4eU+RKhMwNbGrZOOFGL9TcBA3KnrerQ@mail.gmail.com>
	<21677.2491.857663.473071@gargle.gargle.HOWL>
Date: Mon, 12 Jan 2015 13:51:48 +0200
In-Reply-To: <21677.2491.857663.473071@gargle.gargle.HOWL> (Sujith Manoharan's
	message of "Wed, 7 Jan 2015 15:56:03 +0530")
Message-ID: <87ppakdxnv.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_125222_789252_2E635CD7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Michal Kazior wrote:
>> Since it's for cards/chips why do you enable it for 10.2 only? There's
>> 10.1, main and tlv as well which could possibly benefit from this.
>
> I've not tested it with any of the FW versions other than 10.2 and
> am not sure if older FW support this properly. We could try it
> with 10.1, I guess - but even that is in 'maintenance mode'
> internally.

Yeah, I don't see much point of trying to improve our 10.1 support as
all the new development happens on 10.2 branch. Most important is that
we don't break 10.1 support ("no regressions" rule), but it in no way
does 10.1 need to be in feature parity with 10.2.

-- 
Kalle Valo
