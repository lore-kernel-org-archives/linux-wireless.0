Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24158 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965524Ab3GSKgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 06:36:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<ymir.kr@gmail.com>
Subject: Re: [PATCH] ath10k: fix NULL dereference for injected packets
References: <CAMQ0DfRpqk6ufb4rAifjy651oM9-GZyDpMLL+mGVzzVSVjVyJA@mail.gmail.com>
	<1373965494-17726-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 19 Jul 2013 13:36:05 +0300
In-Reply-To: <1373965494-17726-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 16 Jul 2013 11:04:54 +0200")
Message-ID: <87r4eu4z1m.fsf@kamboji.qca.qualcomm.com> (sfid-20130719_123636_626283_B57DC765)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Tx processing functions dereference vif and caused
> NULL to be dereferenced for injected frames.
>
> Don't call these functions at all for injected
> frames. It doesn't make much sense to do so
> anyway.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
